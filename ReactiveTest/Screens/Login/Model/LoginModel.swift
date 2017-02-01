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

class LoginModel {

    let disposeBag = DisposeBag()
    
    func login(withUsername username: String, withPassword password:String, complete: @escaping (Bool) -> Void, error: @escaping (Swift.Error) -> Void) {
        let provider = RxMoyaProvider<GitHubService>(plugins: [ BasicAuthPlugin(username: username, password: password) ])
        provider.request(.getUser).subscribe(onNext: { response in
            let userJson = String(data: response.data, encoding: .utf8)
            print("User:\n\(userJson)")
            complete(response.statusCode == 200)
        }, onError: { moyaError in
            error(moyaError)
        })
        .addDisposableTo(disposeBag)
    }
    
}
