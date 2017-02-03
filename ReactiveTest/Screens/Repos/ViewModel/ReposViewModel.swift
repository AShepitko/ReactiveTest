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
    
    let repos = Variable<[Repo]>([])
    let error = Variable<Error?>(nil)
    
    func fetchRepos(forUser user: User) {
        self.model.fetchRepos(forUser: user, complete: { [unowned self] repos in
            self.repos.value = repos
        }, error: { [unowned self] error in
            self.error.value = error
        })
    }
    
}
