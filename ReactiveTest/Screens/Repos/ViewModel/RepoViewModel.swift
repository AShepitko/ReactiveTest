//
//  RepoViewModel.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 06/02/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import Foundation
import RxSwift

class RepoViewModel {
    
    private let model = RepoModel()
    
    let repo = Variable<Repo?>(nil)
    let error = Variable<Error?>(nil)
    
    func fetchRepoInfo(forRepo repo: Repo) {
        self.model.fetchRepoInfo(forRepo: repo, complete: { [unowned self] repo in
            self.repo.value = repo
        }, error: { [unowned self] error in
            self.error.value = error
        })
    }

}
