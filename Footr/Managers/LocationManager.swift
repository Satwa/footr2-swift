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
    
    @Published var lastKnownLocation: CLLocation? = nil
    @Published var cityName: String? = nil
    @Published var weather: String? = nil
    
    override init() {
        self.locManager = CLLocationManager()
        super.init()
        self.startUpdating()
    }
    
    init(globally: Bool){
        self.locManager = CLLocationManager()
        super.init()
        if globally {
            self.startUpdatingGlobally()
        }else {
            self.startUpdating()
        }
    }
    
    func startUpdating() {
        self.locManager.delegate = self
        self.locManager.requestWhenInUseAuthorization()
        self.locManager.startUpdatingLocation()
    }
    
    func startUpdatingGlobally(){
        self.locManager.delegate = self
        self.locManager.requestAlwaysAuthorization()
        self.locManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if lastKnownLocation == nil && locations.last != nil {
            // Download weather once
//            let coordinates: CLLocationCoordinate2D = locations.last!.coordinate
//            Alamofire.request("https://api.openweathermap.org/data/2.5/weather?lat=" + String(coordinates.latitude) + "&lon=" + String(coordinates.latitude) + "&units=metric&APPID=b41a0945abd378f7fe6b59932c05c184").responseJSON { response in
//                if let json = response.result.value {
//                    let data = JSON(json)
//                    self.weather = data["main"]["temp"].stringValue + "°C" // TODO: Cache for 4hrs
//                }
//            }
            self.weather = "32°C"
            
            
            // Fetch city name
            CLGeocoder().reverseGeocodeLocation(locations.last!) { placemarks, error in
                if let firstPlacemark = placemarks?.first {
                    if self.cityName != firstPlacemark.locality!{
                        self.cityName = String(firstPlacemark.locality!)
                    }
                }
            }
			
			// Fetch monuments and tags
        }
        
        lastKnownLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
}
