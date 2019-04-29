//
//  EventReporter.swift
//  AnalyticsSDKProject
//
//  Created by Admin on 28/04/2019.
//  Copyright © 2019 Devnostics. All rights reserved.
//

import UIKit

class EventReporter: UIViewController {

    var eventQueue = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func sendEvent(name: String,  param: String? = nil)
    {
        
        // Adding an event to the eventQueue
        eventQueue.append([
            "name": name,
            "param": param,
            "timestamp": Date().timeIntervalSince1970
            ])
        
        
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
