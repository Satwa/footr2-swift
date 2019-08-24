//
//  LocationManager.swift
//  LocMe
//
//  Created by Joshua Tabakhoff on 10/07/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire
import SwiftyJSON
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
	internal let objectWillChange = ObservableObjectPublisher()
	
	private let locManager: CLLocationManager
    
	@Published var monumentsManager: MonumentsManager = MonumentsManager()
	@Published var tagsManager: TagsManager = TagsManager()
	
    @Published var lastKnownLocation: CLLocation? = nil
    @Published var cityName: String? = nil
    @Published var weather: String? = nil
	
	let notificationsManager: NotificationsManager = NotificationsManager()
	let historyManager: HistoryManager = HistoryManager()
	
	var selectedTags: [Tag] = [] // when location in background
	var startedLounging: Bool = false
    
    override init() {
        self.locManager = CLLocationManager()
        super.init()
		
		self.locManager.delegate = self
		self.locManager.activityType = .fitness
		self.locManager.requestAlwaysAuthorization()
		self.locManager.startUpdatingLocation()
		self.locManager.startUpdatingHeading()
    }
    
	func startUpdatingInBackground(){
		locManager.allowsBackgroundLocationUpdates = true
		locManager.pausesLocationUpdatesAutomatically = false
		locManager.startMonitoringSignificantLocationChanges()
	}
	func stopUpdatingInBackground(){
		locManager.stopUpdatingLocation()
		locManager.stopUpdatingHeading()
		locManager.allowsBackgroundLocationUpdates = false
		locManager.pausesLocationUpdatesAutomatically = false
		locManager.stopMonitoringSignificantLocationChanges()
	}
	
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		fetchOnceWhenLocationFound(locations: locations)
		lookForNotificationDelivery(locations: locations)
		
		lastKnownLocation = locations.last
//		print("\(Date.timeIntervalSinceReferenceDate): location changed")
    }
    
	fileprivate func fetchOnceWhenLocationFound(locations: [CLLocation]){
        if lastKnownLocation == nil && locations.last != nil {
            // Fetch weather once
			let coordinates: CLLocationCoordinate2D = locations.last!.coordinate
			
			let invalidateTime = UserDefaults.standard.double(forKey: "footr_invalidate")
			
			if invalidateTime != 0.0 && invalidateTime > Date.timeIntervalSinceReferenceDate {
				self.weather = UserDefaults.standard.string(forKey: "footr_weather")
			} else {
				Alamofire.request("https://api.openweathermap.org/data/2.5/weather?lat=" + String(coordinates.latitude) + "&lon=" + String(coordinates.longitude) + "&units=metric&APPID=b41a0945abd378f7fe6b59932c05c184").responseJSON { response in
					if let json = response.result.value {
						let data = JSON(json)
						
						self.weather = String(Int(data["main"]["temp"].doubleValue)) + "°C"
						self.objectWillChange.send() //while this is still buggy
						
						// Cache for 4hrs
						UserDefaults.standard.set(self.weather, forKey: "footr_weather")
						UserDefaults.standard.set(Date.timeIntervalSinceReferenceDate + 4*60*60, forKey: "footr_invalidate")
					}
				}
			}
            
            // Fetch city name once
            CLGeocoder().reverseGeocodeLocation(locations.last!) { placemarks, error in
                if let firstPlacemark = placemarks?.first {
                    if self.cityName != firstPlacemark.locality!{
						self.cityName = String(firstPlacemark.locality!)
						self.objectWillChange.send() //while this is still buggy
                    }
                }
            }
			
			// Fetch monuments and tags
			tagsManager.load()
			
			monumentsManager.load(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
			self.objectWillChange.send() //while this is still buggy
        }
	}
	
	fileprivate func lookForNotificationDelivery(locations: [CLLocation]){
		if locations.last == nil {
			return
		}
		
		// Prepare notifications when updating location
		if startedLounging {
			let selectedTags = tagsManager.tags.filter{ $0.selected ?? true }.map{ $0.filter_equivalence }.flatMap{ $0 }
			
			for i in 0..<monumentsManager.monuments.count {
				let monument = monumentsManager.monuments[i]
				let monumentLocation = CLLocation(latitude: monument.latitude, longitude: monument.longitude)
				
				let includes = monument.filters.filter { selectedTags.contains($0) }
				
				let monumentsNear: Double = 200 // in meters
				if locations.last!.distance(from: monumentLocation) <= monumentsNear && includes.count > 0 {
					notificationsManager.scheduleNotification(monument: monument)
					self.monumentsManager.markAsAnnounced(idx: i)
				}
			}
			
			// Save position every 100 meters
			let lastpos = historyManager.getLastPosition()! // not crash-proof
			let lastpos_coordinates = CLLocation(latitude: lastpos.latitude, longitude: lastpos.longitude)
			
			if locations.last!.distance(from: lastpos_coordinates) < 100 { // save every 100meters
				historyManager.addPosition(location: locations.last!.coordinate)
			}
			
		}
	}
	
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
			manager.startUpdatingLocation()
        }
    }
}
