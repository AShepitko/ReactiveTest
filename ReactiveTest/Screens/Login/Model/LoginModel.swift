//
//  LoginModel.swift
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

class LoginModel {

    let disposeBag = DisposeBag()
    
    func login(withUsername username: String, withPassword password:String, complete: @escaping (User) -> Void, error: @escaping (Swift.Error) -> Void) {
        let provider = RxMoyaProvider<GitHubService>(plugins: [ BasicAuthPlugin(username: username, password: password), JsonNetworkLoggerPlugin() ])
        provider.request(.getUser).filterSuccessfulStatusCodes().subscribe(onNext: { response in
            let json = JSON(response.data)
            let serverID = json["id"].intValue
            let fetchRequest = User.fetchRequest() as NSFetchRequest<User>
            fetchRequest.predicate = NSPredicate(format: "serverID == \(serverID)")
            do {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    var user = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest).first
                    if user == nil {
                        user = User(context: appDelegate.persistentContainer.viewContext)
                    }
                    if let user = user {
                        user.avatarURL = json["avatar_url"].stringValue
                        user.company = json["company"].stringValue
                        user.createdAt = DatesService.shared.parseJsonDate(jsonDate: json["created_at"].stringValue) as NSDate?
                        user.email = json["email"].stringValue
                        user.htmlURL = json["html_url"].stringValue
                        user.login = json["login"].stringValue
                        user.name = json["name"].stringValue
                        user.serverID = Int64(serverID)
                        appDelegate.saveContext()
                        
                        complete(user)
                    }
                }
            }
            catch let e as NSError {
                error(e)
            }
        }, onError: { moyaError in
            error(moyaError)
        })
        .addDisposableTo(disposeBag)
    }
    
}
