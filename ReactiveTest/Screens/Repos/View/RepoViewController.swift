//
//  RepoViewController.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 06/02/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepoViewController: UIViewController {

    @IBOutlet weak var serverIDLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    var repo: Repo?
    
    let modelView = RepoViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modelView.repo.asDriver().drive(onNext: { [unowned self] repo in
            self.serverIDLabel.text = repo?.serverID.description
            self.nameLabel.text = repo?.name
            self.fullNameLabel.text = repo?.fullName
            self.createdAtLabel.text = repo?.createdAt?.description
        }).addDisposableTo(disposeBag)
        
        if let repo = repo {
            modelView.fetchRepoInfo(forRepo: repo)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
