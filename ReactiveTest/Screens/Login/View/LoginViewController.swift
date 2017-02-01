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

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let viewModel = LoginViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.rx.text.bindNext { [unowned self] text in
            if let text = text {
                self.viewModel.username.value = text
            }
        }.addDisposableTo(disposeBag)
        let usernameValidObserver = usernameTextField.rx.text.map({ (text) -> Bool in
            return (text?.characters.count)! > 0
        })
        
        passwordTextField.rx.text.bindNext { text in
            if let text = text {
                self.viewModel.password.value = text
            }
        }.addDisposableTo(disposeBag)
        let passwordValidObserver = passwordTextField.rx.text.map({ (text) -> Bool in
            return (text?.characters.count)! > 0
        })
        
        Observable.combineLatest(usernameValidObserver, passwordValidObserver) { (v1, v2) -> Bool in
            return v1 && v2
        }.bindTo(loginButton.rx.isEnabled).addDisposableTo(disposeBag)
        
        loginButton.rx.tap.subscribe(onNext: { () in
            self.viewModel.login().subscribeOn(MainScheduler.instance).subscribe(onNext: { authenticated in
                self.errorLabel.isHidden = authenticated
                if authenticated {
                    let reposStoryboard = UIStoryboard(name: "Repos", bundle: nil)
                    if let reposNavigationController = reposStoryboard.instantiateInitialViewController() {
                        self.present(reposNavigationController, animated: true, completion: nil)
                    }
                }
                else {
                    self.errorLabel.text = NSLocalizedString("Unauthorized", comment: "")
                }
            }, onError: { error in
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Error: \(error)"
            }).addDisposableTo(self.disposeBag)
        }).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
