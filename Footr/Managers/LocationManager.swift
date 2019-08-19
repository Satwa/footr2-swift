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
    private let locManager: CLLocationManager
    
	private let monumentsManager: MonumentsManager = MonumentsManager()
	private let tagsManager: TagsManager = TagsManager()
	
    @Published var lastKnownLocation: CLLocation? = nil
    @Published var cityName: String? = nil
    @Published var weather: String? = nil
	@Published var tags: [Tags] = []
	@Published var monuments: [Monuments] = []
    
    override init() {
        self.locManager = CLLocationManager()
        super.init()
		
		self.locManager.delegate = self
		self.locManager.activityType = .fitness
		self.locManager.requestAlwaysAuthorization()
		self.locManager.startUpdatingLocation()
    }
    
	func startUpdatingInBackground(){
		locManager.allowsBackgroundLocationUpdates = true
		locManager.pausesLocationUpdatesAutomatically = false
		locManager.startMonitoringSignificantLocationChanges()
	}
	func stopUpdatingInBackground(){
		locManager.allowsBackgroundLocationUpdates = false
		locManager.pausesLocationUpdatesAutomatically = false
		locManager.stopMonitoringSignificantLocationChanges()
	}
	
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if lastKnownLocation == nil && locations.last != nil {
            // Fetch weather once
			let coordinates: CLLocationCoordinate2D = locations.last!.coordinate
			
			let invalidateTime = UserDefaults.standard.double(forKey: "footr_invalidate")
			if invalidateTime != 0.0 && invalidateTime > Date.timeIntervalBetween1970AndReferenceDate {
				print("load from cache")
				self.weather = UserDefaults.standard.string(forKey: "footr_weather")
			} else {
				Alamofire.request("https://api.openweathermap.org/data/2.5/weather?lat=" + String(coordinates.latitude) + "&lon=" + String(coordinates.latitude) + "&units=metric&APPID=b41a0945abd378f7fe6b59932c05c184").responseJSON { response in
					if let json = response.result.value {
						let data = JSON(json)
						self.weather = data["main"]["temp"].stringValue + "°C"
						
						// Cache for 4hrs
						UserDefaults.standard.set(self.weather, forKey: "footr_weather")
						UserDefaults.standard.set(Date.timeIntervalBetween1970AndReferenceDate + 4*60*60, forKey: "footr_invalidate")
					}
				}
			}
            
            
            // Fetch city name once
            CLGeocoder().reverseGeocodeLocation(locations.last!) { placemarks, error in
                if let firstPlacemark = placemarks?.first {
                    if self.cityName != firstPlacemark.locality!{
                        self.cityName = String(firstPlacemark.locality!)
                    }
                }
            }
			
			// Fetch monuments and tags
			tagsManager.load()
			self.tags = tagsManager.tags
			
			monumentsManager.load(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
			self.monuments = monumentsManager.monuments
        }
        
        lastKnownLocation = locations.last
		
		print("\(Date.timeIntervalSinceReferenceDate): location changed")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
}
