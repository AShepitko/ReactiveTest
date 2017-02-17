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
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = LoginViewModel(usernameObservable: usernameTextField.rx.text.orEmpty.asDriver(),
                                       passwordObservable: passwordTextField.rx.text.orEmpty.asDriver(),
                                       loginTaps: loginButton.rx.tap.asDriver())
        
        viewModel.loggedInUser.drive(onNext: { [unowned self] user in
            if let user = user {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.username = self.usernameTextField.text!
                    appDelegate.password = self.passwordTextField.text!
                }
                
                let reposStoryboard = UIStoryboard(name: "Repos", bundle: nil)
                if let reposNavigationController = reposStoryboard.instantiateInitialViewController() as? UINavigationController {
                    if let reposController = reposNavigationController.viewControllers[0] as? ReposViewController {
                        reposController.user = user
                    }
                    self.present(reposNavigationController, animated: true, completion: nil)
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.loginEnabled.drive(onNext: { [unowned self] enabled in
            self.loginButton.isEnabled = enabled
        }).disposed(by: disposeBag)
        
        viewModel.loginInProgress.drive(onNext: { [unowned self] inProgress in
            if inProgress {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            else {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }).disposed(by: disposeBag)
        
        viewModel.loginError.asDriver().drive(onNext: { error in
            self.errorLabel.isHidden = (error == nil)
            if let error = error {
                self.errorLabel.text = "Login error: \(error)"
            }
        }).disposed(by: disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
