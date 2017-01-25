//
//  Episode+CoreDataClass.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 25/01/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Episode)
public class Episode: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode");
    }
    
    @NSManaged public var serverID: Int64
    @NSManaged public var url: String?
    @NSManaged public var name: String?
    @NSManaged public var number: Int16
    @NSManaged public var imageUrl: String?
    @NSManaged public var summary: String?
    @NSManaged public var season: Season?

}
