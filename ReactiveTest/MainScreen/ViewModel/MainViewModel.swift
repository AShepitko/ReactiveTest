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
    
    public struct SeriesModel {
        var serverID: Int?
        var url: String?
        var name: String?
        var imageUrl: String?
        var genres: String?
        var summary: String?
        var seasons: NSSet?
    }

    var series: Variable<SeriesModel> = Variable(SeriesModel())
    
    func fetchData() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            var requestResult:[Series] = []
            let fetchRequest = Series.fetchRequest() as NSFetchRequest<Series>
            do {
                requestResult = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
                if requestResult.count > 0 {
                    if let cachedSeries = requestResult.first {
                        self.series.value.serverID = Int(cachedSeries.serverID)
                        self.series.value.url = cachedSeries.url
                        self.series.value.name = cachedSeries.name
                        self.series.value.imageUrl = cachedSeries.imageUrl
                        self.series.value.summary = cachedSeries.summary
                    }
                }
                
                let configuration = URLSessionConfiguration.default
                let session = URLSession(configuration: configuration)
                session.dataTask(with: URL(string: "https://dl.dropboxusercontent.com/u/65496631/got.json")!) { (data, response, error) in
                    print("Response: \(response)")
                    if let data = data {
                        let json = JSON(data: data)
                        self.series.value.serverID = json["id"].intValue
                        self.series.value.url = json["url"].stringValue
                        self.series.value.name = json["name"].stringValue
                        self.series.value.imageUrl = json["image"]["original"].stringValue
                        self.series.value.summary = json["summary"].stringValue
                        self.saveData()
                    }
                }
                .resume()
                
            }
            catch let error as NSError {
                print("Fetch error: \(error)")
            }
        }
    }
    
    func saveData() {
        //TODO: save on server
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            var requestResult:[Series] = []
            let fetchRequest = Series.fetchRequest() as NSFetchRequest<Series>
            do {
                requestResult = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
                let seriesValue = (requestResult.count > 0) ? requestResult.first : NSEntityDescription.insertNewObject(forEntityName: "Series", into: appDelegate.persistentContainer.viewContext) as? Series
                if let value = seriesValue {
                    value.serverID = Int64(series.value.serverID!)
                    value.url = series.value.url
                    value.name = series.value.name
                    value.imageUrl = series.value.imageUrl
                    value.summary = series.value.summary
                    appDelegate.saveContext()
                }
            }
            catch let error as NSError {
                print("Fetch error: \(error)")
            }
            appDelegate.saveContext()
        }
    }
    
}
