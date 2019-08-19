//
//  NotificationsManager.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 18/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import Foundation
//import Combine
import SwiftUI
import UserNotifications

let notificationCenter = UNUserNotificationCenter.current()

class NotificationsManager: ObservableObject{
    class NotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate{
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .sound])
        }
    }
    
    let uncDelegate = NotificationCenterDelegate()
    
    init(){
        notificationCenter.delegate = uncDelegate
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                print("Not authorized")
                // Notifications not allowed
                // wip: do something
            }
        }
    }
	
	func askForPermission(){
		notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
			print(error as Any)
		}
	}
    
    func scheduleNotification(monument: Monuments){
        let content = UNMutableNotificationContent()
        content.title = "Places nearby"
		content.body = monument.name
        content.sound =  .default
        
        let identifier = "FootrPlaceNotification_\(UUID())"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

		if !(monument.announced ?? false) && !(monument.ignored ?? false) {
			notificationCenter.add(request, withCompletionHandler: { (error) in
				if let error = error {
					// Something went wrong
					print("error happened: \(error)")
				}
			})
		}
    }
	
	func cancelNotifications(){
		notificationCenter.removeAllPendingNotificationRequests() // when walk ended
	}
    
}
