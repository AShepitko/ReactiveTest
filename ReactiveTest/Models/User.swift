//
//  User.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 14/02/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import RealmSwift

class User: Object {
    
    dynamic var id: Int64 = 0
    dynamic var avatarURL: String?
    dynamic var company: String?
    dynamic var createdAt: NSDate?
    dynamic var email: String?
    dynamic var htmlURL: String?
    dynamic var login: String?
    dynamic var name: String?

    let repos = List<Repo>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
