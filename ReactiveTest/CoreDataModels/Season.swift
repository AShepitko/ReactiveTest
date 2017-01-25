//
//  Season+CoreDataClass.swift
//  ReactiveTest
//
//  Created by Alexei Shepitko on 25/01/2017.
//  Copyright © 2017 Distillery. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Season)
public class Season: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Season> {
        return NSFetchRequest<Season>(entityName: "Season");
    }
    
    @NSManaged public var number: Int16
    @NSManaged public var series: Series?
    @NSManaged public var episodes: NSSet?

}

// MARK: Generated accessors for episodes
extension Season {
    
    @objc(addEpisodesObject:)
    @NSManaged public func addToEpisodes(_ value: Episode)
    
    @objc(removeEpisodesObject:)
    @NSManaged public func removeFromEpisodes(_ value: Episode)
    
    @objc(addEpisodes:)
    @NSManaged public func addToEpisodes(_ values: NSSet)
    
    @objc(removeEpisodes:)
    @NSManaged public func removeFromEpisodes(_ values: NSSet)
    
}
