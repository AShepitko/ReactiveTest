//
//  LoginViewController.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 31/01/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let viewModel = LoginViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.user.asDriver().drive(onNext: { user in
            guard let user = user else {
                return
            }
            guard let username = self.usernameTextField.text else {
                return
            }
            guard let password = self.passwordTextField.text else {
                return
            }
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.username = username
                appDelegate.password = password
            }
            
            let reposStoryboard = UIStoryboard(name: "Repos", bundle: nil)
            if let reposNavigationController = reposStoryboard.instantiateInitialViewController() as? UINavigationController {
                if let reposController = reposNavigationController.viewControllers[0] as? ReposViewController {
                    reposController.user = user
                }
                self.present(reposNavigationController, animated: true, completion: nil)
            }
        }).addDisposableTo(disposeBag)
        
        viewModel.error.asDriver().drive(onNext: { error in
            guard let error = error else {
                self.errorLabel.isHidden = true
                return
            }
            self.errorLabel.isHidden = false
            self.errorLabel.text = "Error: \(error)"
        }).addDisposableTo(disposeBag)
        
        let usernameValidObserver = usernameTextField.rx.text.map({ (text) -> Bool in
            return (text?.characters.count)! > 0
        })
        let passwordValidObserver = passwordTextField.rx.text.map({ (text) -> Bool in
            return (text?.characters.count)! > 0
        })
        Observable.combineLatest(usernameValidObserver, passwordValidObserver) { (v1, v2) -> Bool in
            return v1 && v2
        }.bindTo(loginButton.rx.isEnabled).addDisposableTo(disposeBag)
        
        loginButton.rx.tap.subscribe(onNext: { [unowned self] () in
            guard let username = self.usernameTextField.text else {
                return
            }
            guard let password = self.passwordTextField.text else {
                return
            }

            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.viewModel.login(username: username, password: password).subscribe(onError: { [unowned self] error in
                MBProgressHUD.hide(for: self.view, animated: true)
            }, onCompleted: { [unowned self] in
                MBProgressHUD.hide(for: self.view, animated: true)
            }).addDisposableTo(self.disposeBag)
        }).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
