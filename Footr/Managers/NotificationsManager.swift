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
//			print(error as Any)
		}
	}
    
    func scheduleNotification(monument: Monument){
        let content = UNMutableNotificationContent()
        content.title = "Place nearby — \(monument.name)"
		content.body = String(monument.description?.split(separator: ".")[0] ?? "\(monument.name)")
		
		if let data = monument.illustration_data {
			guard let attachment = UNNotificationAttachment.saveImageToDisk(fileIdentifier: "image.jpg", data: data as NSData, options: nil) else {
				print("error happened in UNNotificationAttachment.saveImageToDisk()")
				return
			}

			content.attachments = [attachment]
		}
        content.sound =  .default
        
        let identifier = "FootrPlaceNotification_\(UUID())"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

		if !(monument.announced ?? false) && !(monument.ignored ?? false) {
			print("happened: display notification")
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
