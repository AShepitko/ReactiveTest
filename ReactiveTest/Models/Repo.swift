//
//  Repo.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 14/02/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import RealmSwift

class Repo: Object {

    dynamic var id: Int64 = 0
    dynamic var createdAt: NSDate?
    dynamic var desc: String?
    dynamic var fullName: String?
    dynamic var htmlURL: String?
    dynamic var isPrivate: Bool = false
    dynamic var name: String?
    dynamic var size: Int64 = 0
    
    let accessibleUser = LinkingObjects(fromType: User.self, property: "accessibleRepos")
    let owner = LinkingObjects(fromType: Owner.self, property: "ownRepos")
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
