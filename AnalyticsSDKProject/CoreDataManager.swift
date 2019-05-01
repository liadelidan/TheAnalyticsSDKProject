//
//  CoreDataManager.swift
//  AnalyticsSDKProject
//
//  Created by Liad Elidan on 28/04/2019.
//  Copyright © 2019 All rights reserved.
//

import Foundation
import CoreData

// CoreDataManager that deals with managing the CoreData.
public class CoreDateManager {
    
    // Creating the shared static variable to be used.
    public static let shared = CoreDateManager()
    
    let identifier: String  = "Optimove.AnalyticsSDKProject"
    let model: String       = "Model"
    
    // PersistentContainer creation.
    lazy var persistentContainer: NSPersistentContainer = {
        
        let messageKitBundle = Bundle(identifier: self.identifier)
        let modelURL = messageKitBundle!.url(forResource: self.model, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            
            if let err = error{
                fatalError("❌ Loading of store failed:\(err)")
            }
        }
        
        return container
    }()
    
    // Adding the Event to the CoreData.
    public func createEvent(name: String, param: String? = nil)
    {
        // creating the context with our persistent container.
        let context = persistentContainer.viewContext
        // Choosing a specific Entity -> Event to be inserted to.
        let specEvent = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context) as! Event
        
        // Filling up the appropriate parts of the event, name, param if exist and
        // timestamp.
        specEvent.name = name
        // Checking if we used the optional param or not.
        if (param != nil)
        {
            specEvent.param  = param
        }
        specEvent.timestamp = Date().timeIntervalSince1970
        
        // Saving the CoreData context.
        do {
            try context.save()
            print("✅ Event saved succesfuly")
            
        } catch let error {
            print("❌ Failed to create an Event: \(error.localizedDescription)")
        }
    }
    
    // Function to fetch the data and return it as an array of Events.
    public func fetch() -> [Event]
    {
        let context = persistentContainer.viewContext
        let events = try? context.fetch(Event.fetchRequest()) as? [Event]

        return events!
    }
    
    // Function to delete all the data in the CoreData, used to reset the
    // queue of data after it is filled with 5 events.
    public func deleteData()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        fetchRequest.returnsObjectsAsFaults = false
        let context = persistentContainer.viewContext
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
            
            do {
                try context.save()
                print("✅ Deleted all data succesfuly")
                
            } catch let error {
                print("❌ Failed to delete data: \(error.localizedDescription)")
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
}
