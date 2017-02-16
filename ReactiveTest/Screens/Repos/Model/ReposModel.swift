//
//  ReposModel.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 31/01/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
import RealmSwift

class ReposModel {
    
    let disposeBag = DisposeBag()
    
    func fetchRepos(forUser user: User, complete: @escaping ([Repo]) -> Void, error: @escaping (Swift.Error) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // fetch local data
        let repos = Array(user.accessibleRepos)
        complete(repos)
        
        // fetch server data
        let provider = RxMoyaProvider<GitHubService>(plugins: [ BasicAuthPlugin(username: appDelegate.username, password: appDelegate.password), JsonNetworkLoggerPlugin() ])
        provider.request(.getRepos).filterSuccessfulStatusCodes().subscribe(onNext: { response in
            let jsonRepos = JSON(response.data)
            do {
                let realm = try Realm()
                realm.beginWrite()
                jsonRepos.arrayValue.forEach({ jsonRepo in
                    let serverID = jsonRepo["id"].int64Value
                    let repo = realm.create(Repo.self, value: [ "id": serverID ], update: true)
                    repo.createdAt = DatesService.shared.parseJsonDate(jsonDate: jsonRepo["created_at"].stringValue) as NSDate?
                    repo.desc = jsonRepo["description"].stringValue
                    repo.fullName = jsonRepo["full_name"].stringValue
                    repo.htmlURL = jsonRepo["html_url"].stringValue
                    repo.isPrivate = jsonRepo["private"].boolValue
                    repo.name = jsonRepo["name"].stringValue
                    repo.size = jsonRepo["size"].int64Value
                    if !user.accessibleRepos.contains(repo) {
                        user.accessibleRepos.append(repo)
                    }
                    
                    let jsonOwner = jsonRepo["owner"]
                    let ownerID = jsonOwner["id"].int64Value
                    let owner = realm.create(Owner.self, value: [ "id": ownerID ], update: true)
                    owner.avatarURL = jsonOwner["avatar_url"].stringValue
                    owner.login = jsonOwner["login"].stringValue
                    owner.htmlURL = jsonOwner["html_url"].stringValue
                    if !owner.ownRepos.contains(repo) {
                        owner.ownRepos.append(repo)
                    }

                })
                try realm.commitWrite()
                complete(Array(user.accessibleRepos))
            } catch let e as NSError {
                error(e)
            }
        }, onError: { moyaError in
            switch moyaError {
            case Moya.Error.statusCode(let response):
                print("Invalid status code \(response.statusCode)")
            default:
                print("An error occured: \(error)")
            }
            error(moyaError)
        }).addDisposableTo(disposeBag)
    }

}
