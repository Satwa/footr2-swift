//
//  AppDelegate.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 30/07/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import UIKit

let API_ROOT = "http://192.168.1.13:3012/v2/"
// let API_ROOT = "https://pathfinder.joshuatabakhoff.com/api/v2/"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var locationManager: LocationManager = LocationManager()
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

