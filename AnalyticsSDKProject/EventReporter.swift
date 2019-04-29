//
//  EventReporter.swift
//  AnalyticsSDKProject
//
//  Created by Admin on 28/04/2019.
//  Copyright © 2019 Devnostics. All rights reserved.
//

import UIKit
import CoreData

public class EventReporter: UIViewController {

    // The event queue.
    public var eventQueue = [[String: Any]]()
    
    // Core Data variables.
    let persistenceManager: PersistenceManager
    

    private init (persistenceManager: PersistenceManager)
    {
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Getting all the events from the Core Data.
        guard let events = try! persistenceManager.context.fetch(Event.fetchRequest()) as? [Event] else { return }
        
        // Adding each event received from Core Data to the eventQueue.
        for specEvent in events
        {
            eventQueue.append([
                "name": specEvent.name,
                "param": specEvent.param ?? "",
                "timestamp": specEvent.timestamp
                ])
        }

    }
    
    // Helper function to check that the Event Queue works correctly.
    public func printEventQueue()
    {
        for event in eventQueue
        {
            print(event)
        }
    }
    
    // SendEvent function as requested.
    // Sending the events in eventQueue only when there are 5 events,
    // while maintaining the Core Data data.
    public func sendEvent(name: String,  param: String? = nil)
    {
        let timeStamp = Date().timeIntervalSince1970
        // Adding an event to the eventQueue.
        eventQueue.append([
            "name": name,
            "param": param ?? "",
            "timestamp": timeStamp
            ])
        
        // Adding an event to the Core Data.
        let event = Event(context: persistenceManager.context)
        event.name = name
        event.param = param
        event.timestamp = timeStamp
        persistenceManager.save()
        
        // Checking if the eventQueue filled up with 5 requests.
        if (eventQueue.count == 5)
        {
            
            // Creating POST HTTP request data
            let url = URL(string: "https:://demo.url")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Converting the eventQueue to jsonData that can be sent as the POST
            // request body.
            let jsonData = try? JSONSerialization.data(withJSONObject: eventQueue)
            
            // Making sure the eventQueue is empty after converting all the events to
            // json data.
            eventQueue.removeAll()
            
            // Deleteing all the Core Data data because we need it clean as well.
            persistenceManager.deleteData()
            persistenceManager.save()
            
            // Creating the BODY part of the HTTP request.
            request.httpBody = jsonData
            
            // Sending the HTTP POST request.
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {                                              // Checking for fundamental networking error.
                        print("error", error ?? "Unknown error")
                        return
                }
                
                guard (200 ... 299) ~= response.statusCode else {
                    // Checking for http errors.
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
            }
            task.resume()
        }
    }


}
