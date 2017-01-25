//
//  MainViewModel.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 25/01/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import Foundation
import SwiftyJSON

class MainViewModel {

    func test() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        session.dataTask(with: URL(string: "https://dl.dropboxusercontent.com/u/65496631/got.json")!) { (data, response, error) in
            if let data = data {
                let json = JSON(data: data)
                print("JSON:\n\(json)")
            }
        }
        .resume()
    }
    
}
