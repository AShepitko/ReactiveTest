//
//  ReposViewController.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 31/01/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ReposViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?

    let modelView = ReposViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = user {
            modelView.fetchRepos(forUser: user).bindTo(tableView.rx.items(cellIdentifier: "RepoTableViewCell", cellType: RepoTableViewCell.self)) { index, repo, cell in
                cell.nameLabel.text = repo.name
            }.addDisposableTo(disposeBag)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
