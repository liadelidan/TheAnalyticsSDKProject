
import Foundation
import CoreData

public class CoreDateManager {
    
    public static let shared = CoreDateManager()
    
    let identifier: String  = "Optimove.AnalyticsSDKProject"
    let model: String       = "Model"
    
    
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
    
    public func createEvent(name: String, param: String){
        
        let context = persistentContainer.viewContext
        let specEvent = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context) as! Event
        
        specEvent.name = name
        specEvent.param  = param
        specEvent.timestamp = Date().timeIntervalSince1970
        
        do {
            try context.save()
            print("✅ Event saved succesfuly")
            
        } catch let error {
            print("❌ Failed to create an Event: \(error.localizedDescription)")
        }
    }
    
    public func fetch() -> [Event]{
        
        let context = persistentContainer.viewContext
        
        let events = try? context.fetch(Event.fetchRequest()) as? [Event]

        return events!
    }
 
    public func deleteData() {
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
