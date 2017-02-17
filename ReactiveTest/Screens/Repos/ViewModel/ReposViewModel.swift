//
//  ReposViewModel.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 31/01/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import RxSwift
import RxCocoa

class ReposViewModel {

    let repos: Driver<[Repo]>
    let loadingError: Variable<Error?>
    let loadingInProgress: Driver<Bool>
    
    init(withUser user: User, reloadTaps: Driver<Void>) {
        let model = ReposModel()
        
        let errorVariable = Variable<Error?>(nil)
        loadingError = errorVariable
        
        let activityIndicator = ActivityIndicator()
        loadingInProgress = activityIndicator.asDriver()

        repos = reloadTaps.flatMapLatest({ (Void) in
            let observable = model.fetchRepos(forUser: user).trackActivity(activityIndicator)
            return observable.do(onError: { error in
                errorVariable.value = error
            }).asDriver(onErrorJustReturn: Array(user.accessibleRepos))
        })
    }
    
}
