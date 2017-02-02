//
//  GitHubService.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 01/02/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import Foundation
import Moya

enum GitHubService {
    case getUser
    case getRepos
}

extension GitHubService: TargetType {
    
    var baseURL: URL { return URL(string: Constants.URLs.baseURL)! }
    var path: String {
        switch self {
            case .getUser:
                return "/user"
            case .getRepos:
                return "/user/repos"
        }
    }
    var method: Moya.Method {
        switch self {
            case .getUser, .getRepos:
                return .get
        }
    }
    var parameters: [String: Any]? {
        switch self {
            case .getUser, .getRepos:
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
        }
    }
    var task: Task {
        switch self {
            case .getUser, .getRepos:
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
