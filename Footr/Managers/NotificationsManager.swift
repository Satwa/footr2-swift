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
		override init(){
			super.init()
			
			// Declare notification category (and actions related)
			let ignoreAction = UNNotificationAction(identifier: "IGNORE_ACTION",
				  title: "Ignore",
				  options: UNNotificationActionOptions(rawValue: 0))
			
			let directionsAction = UNNotificationAction(identifier: "DIRECTIONS_ACTION",
				  title: "Show me how to get there",
				  options: [.foreground, .authenticationRequired])
			
			let stopAction = UNNotificationAction(identifier: "STOP_ACTION",
				title: "End the walk",
				options: .destructive)
			
			let placeNearbyCategory =
				  UNNotificationCategory(identifier: "PLACE_NEARBY_CAT",
				  actions: [ignoreAction, directionsAction, stopAction],
				  intentIdentifiers: [],
				  hiddenPreviewsBodyPlaceholder: "",
				  options: .customDismissAction)
			
			notificationCenter.setNotificationCategories([placeNearbyCategory]) // later: summaryCategory?
		}
		
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .sound])
        }
		
		func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
			let notification = response.notification.request.content
			
			if notification.categoryIdentifier == "PLACE_NEARBY_CAT" {
				// This notification is related to placeNearbyCategory
				let monument = notification.userInfo["monument_name"] as! String
				let locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
				
				switch response.actionIdentifier {
					case "IGNORE_ACTION":
						locationManager.monumentsManager.markAsIgnored(name: monument)
						
						locationManager.historyManager.manipulateMonument(monument: locationManager.monumentsManager.getMonument(name: monument)!) // this isn't crash-proof
					break
					
					case "DIRECTIONS_ACTION":
						locationManager.monumentsManager.markAsFollowed(name: monument)
						
						locationManager.historyManager.manipulateMonument(monument: locationManager.monumentsManager.getMonument(name: monument)!) // this isn't crash-proof
						
						locationManager.monumentsManager.selectedMonument = locationManager.monumentsManager.monuments.first{ $0.name == monument }
					break

					case "STOP_ACTION":
						locationManager.historyManager.markLastAsStopped()
						locationManager.stopUpdatingInBackground()
						locationManager.startedLounging = false
						locationManager.notificationsManager.cancelNotifications()
					break
					
					default:
					break
				}
			}
			
			completionHandler()
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
		content.categoryIdentifier = "PLACE_NEARBY_CAT"
        content.sound =  .default
		content.userInfo = ["monument_name": monument.name] // will this work?
        
        let identifier = "FootrPlaceNotification_\(UUID())"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

		if !(monument.announced ?? false) && !(monument.ignored ?? false) {
			print("happened: display notification")
			
			let locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
			locationManager.historyManager.manipulateMonument(monument: monument) // this isn't crash-proof
			
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
