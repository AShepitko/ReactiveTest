//
//  Owner.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 16/02/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import RealmSwift

class Owner: Object {
    
    dynamic var id: Int64 = 0
    dynamic var avatarURL: String?
    dynamic var login: String?
    dynamic var htmlURL: String?
    
    let ownRepos = List<Repo>()
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
