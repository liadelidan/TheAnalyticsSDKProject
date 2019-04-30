//
//  Event+CoreDataClass.swift
//  AnalyticsSDKProject
//
//  Created by Admin on 29/04/2019.
//  Copyright © 2019 Devnostics. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Event)
public class Event: NSManagedObject {

}

extension NSManagedObject {
    func toJSON() -> String? {
        let keys = Array(self.entity.attributesByName.keys)
        let dict = self.dictionaryWithValues(forKeys: keys)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let reqJSONStr = String(data: jsonData, encoding: .utf8)
            return reqJSONStr
        }
        catch{}
        return nil
    }
}
