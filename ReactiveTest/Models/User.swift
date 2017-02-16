//
//  User.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 14/02/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//

import RealmSwift

class User: Owner {
    
    dynamic var company: String?
    dynamic var createdAt: NSDate?
    dynamic var email: String?
    dynamic var name: String?
    
    let accessibleRepos = List<Repo>()
    
}
