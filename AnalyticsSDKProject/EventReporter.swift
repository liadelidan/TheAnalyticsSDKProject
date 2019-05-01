//
//  EventReporter.swift
//  AnalyticsSDKProject
//
//  Created by Liad Elidan on 28/04/2019.
//  Copyright © 2019 All rights reserved.
//

import UIKit
import CoreData

// EventReporter class as requested.
public class EventReporter: UIViewController {
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // SendEvent function as requested.
    public func sendEvent(name: String,  param: String? = nil)
    {
        // Adding an event to the Core Data, checking if the
        // optional param exists or not.
        if (param == nil)
        {
            CoreDateManager.shared.createEvent(name: name)
        }
        else
        {
            CoreDateManager.shared.createEvent(name: name, param: param)
        }
        
        // Fetching all the events that exist in the queue from the CoreData.
        let events = CoreDateManager.shared.fetch()
        print("The amount of Entities in Core Data is " + String(CoreDateManager.shared.fetch().count))
        
        // Checking if the amount of the events in the queue filled up with 5 requests.
        if (CoreDateManager.shared.fetch().count >= 5)
        {
            
            // Creating POST HTTP request data
            let url = URL(string: "https:://demo.url")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // Converting the events to JSON data.
            let jsonData = try! JSONEncoder().encode(events)

            // Deleteing all the events from the queue in the CoreData,
            // because we are sending them.
            CoreDateManager.shared.deleteData()
            print("The amount of Entities in Core Data after deleting " + String(CoreDateManager.shared.fetch().count))
            
            // Creating the BODY part of the HTTP request using the JSON data.
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
