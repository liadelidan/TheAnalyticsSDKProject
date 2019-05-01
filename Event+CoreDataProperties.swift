//
//  Event+CoreDataProperties.swift
//  AnalyticsSDKProject
//
//  Created by Liad Elidan on 28/04/2019.
//  Copyright © 2019 All rights reserved.
//

import Foundation
import CoreData

// Event extension to be used within the CoreData as Entity.
extension Event : Encodable{

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event>
    {
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
