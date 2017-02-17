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
import MBProgressHUD

class ReposViewController: UIViewController {
    
    enum Segues {
        static let repoSegue = "ShowRepoSegueID"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        if let user = user {
            appDelegate.username = user.login! + "1" //TODO: simulate auth failure
            
            let refreshItem = UIBarButtonItem(title: "R", style: .plain, target: self, action: nil)
            self.navigationItem.rightBarButtonItems = [ refreshItem ]

            let refreshDriver = refreshItem.rx.tap.asDriver()
            let viewModel = ReposViewModel(withUser: user, reloadTaps: refreshDriver)

            viewModel.repos.asDriver().asObservable().bindTo(tableView.rx.items(cellIdentifier: "RepoTableViewCell", cellType: RepoTableViewCell.self)) { index, repo, cell in
                cell.nameLabel.text = repo.name
            }.addDisposableTo(disposeBag)
            
            tableView.rx.modelSelected(Repo.self).asDriver().drive(onNext: { [unowned self] repo in
                self.performSegue(withIdentifier: Segues.repoSegue, sender: repo)
            }).addDisposableTo(disposeBag)
            
//            viewModel.loadingInProgress.drive(onNext: { [unowned self] inProgress in
//                if inProgress {
//                    MBProgressHUD.showAdded(to: self.view, animated: true)
//                }
//                else {
//                    MBProgressHUD.hide(for: self.view, animated: true)
//                }
//            }).disposed(by: disposeBag)
            
            viewModel.loadingError.asDriver().asObservable().subscribe(onNext: { error in
                if let error = error {
                    appDelegate.username = user.login! //TODO: fix simulated auth failure
                    
                    let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }).addDisposableTo(disposeBag)
            
//            refreshItem.rx.tap.subscribe(onNext: { [unowned self] in
//                appDelegate.username = user.login! //TODO: fix simulated auth failure
//
//                self.modelView.fetchRepos(forUser: user)
//            }).addDisposableTo(disposeBag)
            
            //self.modelView.fetchRepos(forUser: user)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.repoSegue {
            if let destinationController = segue.destination as? RepoViewController {
                destinationController.repo = sender as? Repo
            }
        }
    }
    
}
