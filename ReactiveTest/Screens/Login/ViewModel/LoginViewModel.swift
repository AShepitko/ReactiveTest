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
    
    enum LoginErrors: Error {
        case InvalidCredentials
    }
    
    var username: Variable<String> = Variable("")
    var password: Variable<String> = Variable("")
    
    var model = LoginModel()
    
    func login() -> Observable<Bool> {
        return Observable<Bool>.create({ [unowned self] (observer) -> Disposable in
            
            self.model.login(withUsername: self.username.value, withPassword: self.password.value, complete: { success in
                observer.onNext(success)
                observer.onCompleted()
            }, error: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        })
    }

}
