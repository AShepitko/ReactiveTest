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

    let disposeBag = DisposeBag()
    
    func login(withUsername username: String, withPassword password:String, complete: @escaping (User) -> Void, error: @escaping (Swift.Error) -> Void) {
        let provider = RxMoyaProvider<GitHubService>(plugins: [ BasicAuthPlugin(username: username, password: password), JsonNetworkLoggerPlugin() ])
        provider.request(.getUser).filterSuccessfulStatusCodes().subscribe(onNext: { response in
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
                    
                    complete(user)
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
