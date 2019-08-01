//
//  StartWorkoutIntentHandler.swift
//  WalkIntent
//
//  Created by Joshua Tabakhoff on 09/05/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import Foundation
import Intents

class StartWorkoutIntentHandler: NSObject, INStartWorkoutIntentHandling {
    
    func resolveWorkoutName(for intent: INStartWorkoutIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        let result: INSpeakableStringResolutionResult
        
        if let workoutName = intent.workoutName {
            if workoutName.spokenPhrase == "walk" {
                result = INSpeakableStringResolutionResult.success(with: INSpeakableString(vocabularyIdentifier: "id-workouttype-walk", spokenPhrase: "Walk", pronunciationHint: "walk"))
            }else{
                result = INSpeakableStringResolutionResult.unsupported()
            }
        } else {
            result = INSpeakableStringResolutionResult.needsValue()
        }

        completion(result)
    }
    
    func resolveWorkoutGoalUnitType(for intent: INStartWorkoutIntent, with completion: @escaping (INWorkoutGoalUnitTypeResolutionResult) -> Void) {
        let result: INWorkoutGoalUnitTypeResolutionResult
        
        if intent.workoutGoalUnitType == .second  {
            result = INWorkoutGoalUnitTypeResolutionResult.success(with: .second)
        } else if intent.workoutGoalUnitType == .meter {
            result = INWorkoutGoalUnitTypeResolutionResult.success(with: .meter)
        } else if intent.workoutGoalUnitType == .mile {
            result = INWorkoutGoalUnitTypeResolutionResult.success(with: .mile)
        }else if intent.workoutGoalUnitType == intent.workoutGoalUnitType {
            result = INWorkoutGoalUnitTypeResolutionResult.needsValue()
        }else {
            result = INWorkoutGoalUnitTypeResolutionResult.needsValue()
        }
        
        completion(result)
    }
    
    func handle(intent: INStartWorkoutIntent, completion: @escaping (INStartWorkoutIntentResponse) -> Void) {
        
        let response: INStartWorkoutIntentResponse
        
        guard let _ = intent.workoutName?.spokenPhrase else {
            completion(INStartWorkoutIntentResponse(code: .failureNoMatchingWorkout, userActivity: nil))
            return
        }
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INStartWorkoutIntent.self))
        
        // This is deprecated but working
        response = INStartWorkoutIntentResponse(code: .continueInApp, userActivity: userActivity)
        
        completion(response)
    }
}
