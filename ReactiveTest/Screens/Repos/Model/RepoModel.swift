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
import CoreData

class RepoModel {
    
    let disposeBag = DisposeBag()

    func fetchRepoInfo(forRepo repo: Repo, complete: @escaping (Repo) -> Void, error: @escaping (Swift.Error) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // fetch local data
        complete(repo)
        
        // fetch server data
        let provider = RxMoyaProvider<GitHubService>(plugins: [ BasicAuthPlugin(username: appDelegate.username, password: appDelegate.password) ])
        provider.request(.getRepo(user: appDelegate.username, repo: repo.name!)).filterSuccessfulStatusCodes().subscribe(onNext: { response in
            let jsonRepo = JSON(response.data)
            
            repo.serverID = jsonRepo["id"].int64Value
            repo.createdAt = DatesService.shared.parseJsonDate(jsonDate: jsonRepo["created_at"].stringValue) as NSDate?
            repo.desc = jsonRepo["description"].stringValue
            repo.fullName = jsonRepo["full_name"].stringValue
            repo.htmlURL = jsonRepo["html_url"].stringValue
            repo.isPrivate = jsonRepo["private"].boolValue
            repo.name = jsonRepo["name"].stringValue
            repo.size = jsonRepo["size"].int64Value

            appDelegate.saveContext()
            
            complete(repo)
        }, onError: { moyaError in
            error(moyaError)
        }).addDisposableTo(disposeBag)
    }
    
}
