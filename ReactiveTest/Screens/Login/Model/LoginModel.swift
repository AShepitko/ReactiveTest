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
import RealmSwift

class LoginModel {
    
    func login(withUsername username: String, withPassword password:String) -> Observable<User?> {
        let provider = RxMoyaProvider<GitHubService>(plugins: [ BasicAuthPlugin(username: username, password: password), JsonNetworkLoggerPlugin() ])
        return provider.request(.getUser).filterSuccessfulStatusCodes().flatMapLatest { response in
            return Observable<User?>.create({ observer in
                let json = JSON(response.data)
                let serverID = json["id"].int64Value
                do {
                    let realm = try Realm()
                    
                    try realm.write {
                        let user = realm.create(User.self, value: [ "id": serverID ], update: true)
                        
                        user.avatarURL = json["avatar_url"].stringValue
                        user.company = json["company"].stringValue
                        user.createdAt = DatesService.shared.parseJsonDate(jsonDate: json["created_at"].stringValue) as NSDate?
                        user.email = json["email"].stringValue
                        user.htmlURL = json["html_url"].stringValue
                        user.login = json["login"].stringValue
                        user.name = json["name"].stringValue
                        
                        observer.onNext(user)
                    }
                }
                catch let e as NSError {
                    observer.onError(e)
                }
                return Disposables.create()
            })
            
        }
    }
    
}
