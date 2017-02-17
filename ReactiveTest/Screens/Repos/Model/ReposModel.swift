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
    
    func fetchRepos(forUser user: User) -> Observable<[Repo]> {

        let cachedReposObservable = Observable.from([Array(user.accessibleRepos)])
        
        // fetch server data
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let provider = RxMoyaProvider<GitHubService>(plugins: [ BasicAuthPlugin(username: appDelegate!.username, password: appDelegate!.password), JsonNetworkLoggerPlugin() ])
        let serverReposObservable = provider.request(.getRepos).filterSuccessfulStatusCodes().flatMapLatest({ response in
            return Observable<[Repo]>.create({ observer in
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
                    observer.onNext(Array(user.accessibleRepos))
                } catch let e as NSError {
                    observer.onError(e)
                }
                return Disposables.create()
            })
        })
        return cachedReposObservable.concat(serverReposObservable)
    }

}
