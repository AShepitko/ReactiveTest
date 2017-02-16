//
//  RepoModel.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 06/02/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
import RealmSwift

class RepoModel {
    
    let disposeBag = DisposeBag()

    func fetchRepoInfo(forRepo repo: Repo, complete: @escaping (Repo) -> Void, error: @escaping (Swift.Error) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        guard let ownerLogin = repo.owner.first?.login else {
            return
        }
        
        // fetch local data
        complete(repo)
        
        // fetch server data
        let provider = RxMoyaProvider<GitHubService>(plugins: [ BasicAuthPlugin(username: appDelegate.username, password: appDelegate.password), JsonNetworkLoggerPlugin() ])
        provider.request(.getRepo(user: ownerLogin, repo: repo.name!)).filterSuccessfulStatusCodes().subscribe(onNext: { response in
            let jsonRepo = JSON(response.data)
            do {
                let realm = try Realm()
                try realm.write {
                    let serverID = jsonRepo["id"].int64Value
                    let repo = realm.create(Repo.self, value: [ "id" : serverID ], update: true)
                    repo.createdAt = DatesService.shared.parseJsonDate(jsonDate: jsonRepo["created_at"].stringValue) as NSDate?
                    repo.desc = jsonRepo["description"].stringValue
                    repo.fullName = jsonRepo["full_name"].stringValue
                    repo.htmlURL = jsonRepo["html_url"].stringValue
                    repo.isPrivate = jsonRepo["private"].boolValue
                    repo.name = jsonRepo["name"].stringValue
                    repo.size = jsonRepo["size"].int64Value
                    
                    complete(repo)
                }
            }
            catch let e as NSError {
                error(e)
            }
        }, onError: { moyaError in
            error(moyaError)
        }).addDisposableTo(disposeBag)
    }
    
}
