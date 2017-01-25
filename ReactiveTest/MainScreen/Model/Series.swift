//
//  Series+CoreDataClass.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 25/01/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Series)
public class Series: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Series> {
        return NSFetchRequest<Series>(entityName: "Series");
    }
    
    @NSManaged public var serverID: Int64
    @NSManaged public var url: String?
    @NSManaged public var name: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var genres: String?
    @NSManaged public var summary: String?
    @NSManaged public var seasons: NSSet?

}

// MARK: Generated accessors for seasons
extension Series {
    
    @objc(addSeasonsObject:)
    @NSManaged public func addToSeasons(_ value: Season)
    
    @objc(removeSeasonsObject:)
    @NSManaged public func removeFromSeasons(_ value: Season)
    
    @objc(addSeasons:)
    @NSManaged public func addToSeasons(_ values: NSSet)
    
    @objc(removeSeasons:)
    @NSManaged public func removeFromSeasons(_ values: NSSet)
    
}
