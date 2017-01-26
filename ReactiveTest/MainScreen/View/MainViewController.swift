//
//  MainViewController.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 25/01/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    @IBOutlet weak var serverIDLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageUrlLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var seasonsCountLabel: UILabel!
    
    let viewModel = MainViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.lightGray

        viewModel.series.asObservable().subscribe(onNext: { series in
            if let series = series {
                DispatchQueue.main.async {
                    self.serverIDLabel.text = "ID:\n\(series.serverID.description)"
                    self.urlLabel.text = "URL:\n\(series.url)"
                    if let name = series.name {
                        self.nameTextField.text = name
                    }
                    self.imageUrlLabel.text = "Image:\n\(series.imageUrl)"
                    self.genresLabel.text = "Genres:\n\(series.genres)"
                    self.summaryLabel.text = "Summary:\n\(series.summary)"
                    self.seasonsCountLabel.text = "Seasons:\n\(series.seasons?.count.description)"
                }
            }
        })
        .addDisposableTo(disposeBag)
        
        nameTextField.rx.text.bindNext { text in
            self.viewModel.series.value?.name = text
        }
        .addDisposableTo(disposeBag)
        
        viewModel.fetchData()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tapRecognizer.cancelsTouchesInView = true
        view.addGestureRecognizer(tapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        viewModel.fetchData()
    }
    
    func tapHandler(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        
        viewModel.saveData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
