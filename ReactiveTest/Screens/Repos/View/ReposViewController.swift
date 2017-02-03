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

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        if let user = user {
            appDelegate.username = user.login! + "1" //TODO: simulate auth failure

            modelView.repos.asDriver().asObservable().bindTo(tableView.rx.items(cellIdentifier: "RepoTableViewCell", cellType: RepoTableViewCell.self)) { index, repo, cell in
                cell.nameLabel.text = repo.name
            }.addDisposableTo(disposeBag)
            
            modelView.error.asDriver().asObservable().subscribe(onNext: { error in
                guard let error = error else {
                    return
                }
                
                let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }).addDisposableTo(disposeBag)
            
            let refreshItem = UIBarButtonItem(title: "R", style: .plain, target: self, action: nil)
            refreshItem.rx.tap.subscribe(onNext: { [unowned self] in
                appDelegate.username = user.login! //TODO: fix simulated auth failure

                self.modelView.fetchRepos(forUser: user)
            }).addDisposableTo(disposeBag)
            self.navigationItem.rightBarButtonItems = [ refreshItem ]
            
            self.modelView.fetchRepos(forUser: user)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}
