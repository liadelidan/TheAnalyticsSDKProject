# TheAnalyticsSDKProject

Instructions:

1. Move the SDK folder to your new swift project.

   <img width="272" alt="Screen Shot 2019-05-01 at 19 16 56" src="https://user-images.githubusercontent.com/19635719/57027772-f32f0900-6c45-11e9-8cf7-8b54fd8e572a.png">

2. Embed the SDK in the new swift project.
3. Use the SDK as follows:
   In the swift file you to use the SDK add the following lines:
   
   1. import AnalyticsSDKProject
   
   2. let myEventReporter:EventReporter = EventReporter()
   
   3. 
      Every time you want to add an Event, send the event
      with the appropriate data use this:
      
      myEventReporter.sendEvent(name: "EXAMPLE_NAME", param: "EXAMPLE_PARAM")
      
      or without param:
      
      myEventReporter.sendEvent(name: "EXAMPLE_NAME")
      
   4. The app will send the events when there are 5 events, the events will
      be saved even if you close the app.
      
   5. The BODY of the HTML that will be sent for each event will be as follows:
   
      {
      
        name: EXAMPLE_NAME,
        
        param: EXAMPLE_PARAM, // or null if there was no param provided.
        
        timestamp: TIME // time when received the event.
        
      }
      
   6. The app have been tested with a local server created and works perfect.
      Please note that in order to change the server that the POST request will
      be sent to, that URL needed to be changed in the SDK code.
      The URL currently is as requested in the exercise.
      
   7. Console prints explained:
      I created some console prints that will help to understand what is going
      on in the background and what is being saved on the CoreData at every moment.
      When you add an event, there is a message printed if the event is saved successfully, and 
      a message the shows how many events(entities) exists in the CoreData.
      When the CoreData events reach 5, the data is being deleted. The is a message printed if
      the deleted successfully and a message the verify this by counting the amount of entities
      exist after deletion.
      Provided example of the prints with a seperate projects the works great with the SDK:
      
      <img width="743" alt="Screen Shot 2019-05-01 at 19 29 13" src="https://user-images.githubusercontent.com/19635719/57028330-7a30b100-6c47-11e9-9f1f-3365da83a15b.png">


Thank you for testing my app, hope you have enjoyed it. :-)
Liad Elidan
