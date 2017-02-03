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
    
    private let model = LoginModel()
    
    let user = Variable<User?>(nil)
    let error = Variable<Error?>(nil)
    
    func login(username: String, password: String) -> Observable<Void> {
        return Observable.create({ [unowned self] (observer) -> Disposable in
            self.model.login(withUsername: username, withPassword: password, complete: { [unowned self] user in
                self.user.value = user
                observer.onNext()
                observer.onCompleted()
            }, error: { [unowned self] error in
                self.error.value = error
                observer.onError(error)
            })
            return Disposables.create()
        })
    }

}
