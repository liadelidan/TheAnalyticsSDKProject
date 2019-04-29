//
//  Event+CoreDataProperties.swift
//  AnalyticsSDKProject
//
//  Created by Admin on 29/04/2019.
//  Copyright © 2019 Devnostics. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var name: String
    @NSManaged public var param: String?
    @NSManaged public var timestamp: TimeInterval

}
