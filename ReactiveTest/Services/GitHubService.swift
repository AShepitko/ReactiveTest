//
//  GitHubService.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 01/02/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import Foundation
import Moya
import Result

enum GitHubService {
    case getUser
    case getRepos
    case getRepo(user: String, repo: String)
}

extension GitHubService: TargetType {
    
    var baseURL: URL { return URL(string: Constants.URLs.baseURL)! }
    var path: String {
        switch self {
            case .getUser:
                return "/user"
            case .getRepos:
                return "/user/repos"
            case .getRepo(let user, let repo):
                return "repos/\(user)/\(repo)"
        }
    }
    var method: Moya.Method {
        switch self {
            case .getUser, .getRepos, .getRepo:
                return .get
        }
    }
    var parameters: [String: Any]? {
        switch self {
            case .getUser, .getRepos, .getRepo:
                return nil
        }
    }
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    var sampleData: Data {
        switch self {
            case .getUser:
                return "{}".utf8Encoded
            case .getRepos:
                return "[]".utf8Encoded
            case .getRepo:
                return "{}".utf8Encoded
        }
    }
    var task: Task {
        switch self {
            case .getUser, .getRepos, .getRepo:
                return .request
        }
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}

// MARK: - Auth Plugin
struct BasicAuthPlugin: PluginType {
    let username: String
    let password: String
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        let base64Token = "\(username):\(password)".utf8Encoded.base64EncodedString()
        request.addValue("Basic " + base64Token, forHTTPHeaderField: "Authorization")
        return request
    }
}

// MARK: - Network Logger
struct JsonNetworkLoggerPlugin: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        if let urlRequest = request.request {
            var output = "[REQUEST] \(urlRequest.httpMethod!) \(urlRequest.url!)\n"
            output += "|-Headers:\n"
            if let allHTTPHeaderFields = urlRequest.allHTTPHeaderFields {
                for header in allHTTPHeaderFields {
                    output += "\(header.key): \(header.value)\n"
                }
            }

            output += "|-Body:\n"
            if let httpBody = urlRequest.httpBody {
                do {
                    let json = try JSONSerialization.jsonObject(with: httpBody, options: .allowFragments)
                    let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    output += String(data: data, encoding: .utf8)!
                    if !output.hasSuffix("\n") {
                        output += "\n"
                    }
                } catch {
                    output += "NOT JSON BODY\n"
                }
            }
            output += "|------\n"
            
            print(output)
        }
    }
    
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        var output = ""
        switch result {
        case .success(let response):
            output = "[RESPONSE] \(response.statusCode) \(response.request!.url!)\n"
            output += "|-Headers:\n"
            if let urlResponse = response.response as? HTTPURLResponse {
                for header in urlResponse.allHeaderFields {
                    output += "\(header.key): \(header.value)\n"
                }
            }
            
            output += "|-Body:\n"
            do {
                let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                output += String(data: data, encoding: .utf8)!
                if !output.hasSuffix("\n") {
                    output += "\n"
                }
            } catch {
                output += "NOT JSON BODY\n"
            }
            output += "|------\n"
        case .failure(let error):
            output = "[RESPONSE] ERROR (\(error))\n"
        }
        print(output)
    }

    
}

