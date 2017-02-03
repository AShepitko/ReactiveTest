//
//  LoginViewModel.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 31/01/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {
    
    var username: Variable<String> = Variable("")
    var password: Variable<String> = Variable("")
    
    let model = LoginModel()
    
    func login() -> Observable<User> {
        return Observable<User>.create({ [unowned self] (observer) -> Disposable in
            
            self.model.login(withUsername: self.username.value, withPassword: self.password.value, complete: { user in
                observer.onNext(user)
                observer.onCompleted()
            }, error: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        })
    }

}
