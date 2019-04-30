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


extension Event : Encodable{

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var name: String
    @NSManaged public var param: String?
    @NSManaged public var timestamp: TimeInterval
    
    private enum CodingKeys: String, CodingKey { case name, param, timestamp}
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(param, forKey: .param)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
