//
//  ReposViewModel.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 31/01/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import Foundation
import RxSwift

class ReposViewModel {

    private let model = ReposModel()
    
    func fetchRepos(forUser user: User) -> Observable<[Repo]> {
        return Observable<[Repo]>.create({ [unowned self] (observer) -> Disposable in
            
            self.model.fetchRepos(forUser: user, complete: { repos in
                observer.onNext(repos)
            }, error: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        })
    }
    
}
