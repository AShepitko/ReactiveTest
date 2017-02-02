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
import CoreData

class ReposModel {
    
    let disposeBag = DisposeBag()
    
    func fetchRepos(forUser user: User, complete: @escaping ([Repo]) -> Void, error: @escaping (Swift.Error) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // fetch local data
        let repos = user.repos?.allObjects as! [Repo]
        complete(repos)
        
        // fetch server data
        let provider = RxMoyaProvider<GitHubService>(plugins: [ BasicAuthPlugin(username: appDelegate.username, password: appDelegate.password) ])
        provider.request(.getRepos).subscribe(onNext: { response in
            if response.statusCode == 200 {
                var serverRepos = [Repo]()
                let jsonRepos = JSON(response.data)
                jsonRepos.arrayValue.forEach({ jsonRepo in
                    let serverID = jsonRepo["id"].intValue
                    var repo = repos.first(where: { r -> Bool in
                        return serverID == Int(r.serverID)
                    })
                    if repo == nil {
                        repo = Repo(context: appDelegate.persistentContainer.viewContext)
                        user.addToRepos(repo!)
                    }
                    if let repo = repo {
                        repo.serverID = Int64(serverID)
                        repo.createdAt = DatesService.shared.parseJsonDate(jsonDate: jsonRepo["created_at"].stringValue) as NSDate?
                        repo.desc = jsonRepo["description"].stringValue
                        repo.fullName = jsonRepo["full_name"].stringValue
                        repo.htmlURL = jsonRepo["html_url"].stringValue
                        repo.isPrivate = jsonRepo["private"].boolValue
                        repo.name = jsonRepo["name"].stringValue
                        repo.size = jsonRepo["size"].int64Value
                        
                        serverRepos.append(repo)
                    }
                    appDelegate.saveContext()
                })
                complete(serverRepos)
            }
        }, onError: { moyaError in
            error(moyaError)
        }).addDisposableTo(disposeBag)
    }

}
