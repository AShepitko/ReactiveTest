//
//  LoginViewModel.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 31/01/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewModel {
    
    let loginError: Variable<Error?>
    
    let loggedInUser: Driver<User?>
    let loginEnabled: Driver<Bool>
    let loginInProgress: Driver<Bool>
    
    init(usernameObservable: Driver<String>, passwordObservable: Driver<String>, loginTaps: Driver<Void>) {
        let model = LoginModel()
        
        let usernamePassword = Driver.combineLatest(usernameObservable, passwordObservable) { ($0, $1) }
        
        loginEnabled = Driver.combineLatest(usernameObservable, passwordObservable) { username, password in
            return (username.characters.count > 0) && (password.characters.count > 0)
        }

        let activityIndicator = ActivityIndicator()
        loginInProgress = activityIndicator.asDriver()
        
        let errorVariable = Variable<Error?>(nil)
        loginError = errorVariable
        
        loggedInUser = loginTaps.withLatestFrom(usernamePassword).flatMapLatest({ (username, password) in
            errorVariable.value = nil
            let observable = model.login(withUsername: username, withPassword: password).trackActivity(activityIndicator)
            return observable.do(onError: { error in
                errorVariable.value = error
            }).asDriver(onErrorJustReturn: nil)
        })
    }

}
