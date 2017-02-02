//
//  DatesService.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 02/02/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import UIKit

class DatesService {
    
    static let shared = DatesService()
    
    private lazy var jsonDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    private init() {
        //
    }
    
    func parseJsonDate(jsonDate: String) -> Date? {
        return jsonDateFormatter.date(from: jsonDate)
    }

}
