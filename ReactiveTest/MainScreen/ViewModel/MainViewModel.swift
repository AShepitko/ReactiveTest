//
//  MainViewModel.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 25/01/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import CoreData

class MainViewModel {

    var series: Variable<Series?> = Variable(nil)
    
    func fetchData() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            var requestResult:[Series] = []
            let fetchRequest = Series.fetchRequest() as NSFetchRequest<Series>
            do {
                requestResult = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
                if requestResult.count > 0 {
                    self.series.value = requestResult.first
                }
                
                let configuration = URLSessionConfiguration.default
                let session = URLSession(configuration: configuration)
                session.dataTask(with: URL(string: "https://dl.dropboxusercontent.com/u/65496631/got.json")!) { (data, response, error) in
                    if let data = data {
                        let json = JSON(data: data)
                        let serverID = json["id"].int64Value
                        let url = json["url"].stringValue
                        let name = json["name"].stringValue
                        let imageUrl = json["image"]["original"].stringValue
                        let summary = json["summary"].stringValue
                        if let existingSeries = requestResult.first(where: { $0.serverID == serverID }) {
                            self.series.value = existingSeries
                        }
                        else {
                            self.series.value = NSEntityDescription.insertNewObject(forEntityName: "Series", into: appDelegate.persistentContainer.viewContext) as? Series
                        }
                        self.series.value?.serverID = serverID
                        self.series.value?.url = url
                        self.series.value?.name = name
                        self.series.value?.imageUrl = imageUrl
                        self.series.value?.summary = summary
                        appDelegate.saveContext()
                    }
                }
                .resume()
                
            }
            catch let error as NSError {
                print("Fetch error: \(error)")
            }
        }

    }
    
}
