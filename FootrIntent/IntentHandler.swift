//
//  IntentHandler.swift
//  WalkIntent
//
//  Created by Joshua Tabakhoff on 09/05/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension/*, INStartWorkoutIntentHandling, INEndWorkoutIntentHandling*/ {
//    func handle(intent: INStartWorkoutIntent, completion: @escaping (INStartWorkoutIntentResponse) -> Void) {
//        <#code#>
//    }
//
//    func handle(intent: INEndWorkoutIntent, completion: @escaping (INEndWorkoutIntentResponse) -> Void) {
//        <#code#>
//    }


    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        if intent is INStartWorkoutIntent {
            return StartWorkoutIntentHandler()
        }
//        else if intent is INEndWorkoutIntent {
//            return StopWorkoutIntentHandler()
//        }
        
        return self
    }
    
    
}
