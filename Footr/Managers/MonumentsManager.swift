//
//  MonumentsManager.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 14/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Alamofire

class MonumentsManager: NSObject, ObservableObject {
	@Published var monuments: [Monuments] = []
	
	func load(latitude: Double, longitude: Double){
		// Load from cache or download
		
//		Storage.remove("monuments.json", from: .caches)
		
		// NSDate().timeIntervalSince1970
		if Storage.fileExists("monuments.json", in: .caches) {
			let cache = Storage.retrieve("monuments.json", from: .caches, as: CachedMonuments.self)
			print("LATITUDE: \(cache.last_latitude) | LONGITUDE: \(cache.last_longitude)")
			print("LATITUDE: \(latitude) | LONGITUDE: \(longitude)")
			if cache.last_latitude != latitude.rounded(toPlaces: 3) || cache.last_longitude != longitude.rounded(toPlaces: 3) {
				print("need to download again")
				download(latitude: latitude, longitude: longitude)
				return
			}
			
			self.monuments = cache.monuments
		} else {
			print("Need to download monuments")
			download(latitude: latitude, longitude: longitude)
		}
	}
	
	fileprivate func download(latitude: Double, longitude: Double){
		// Download function and save to cache
		Alamofire.request(
			API_ROOT + "monuments",
			method: .post,
			parameters: ["latitude": latitude, "longitude": longitude]
		).responseData { response in
			do {
				guard let data = response.result.value else { print("ERROR: no data in MM"); return }
				self.monuments = try JSONDecoder().decode([Monuments].self, from: data)
				
				// save to cache
//				Storage.remove("monuments.json", from: .caches)
				Storage.store(CachedMonuments(last_latitude: latitude.rounded(toPlaces: 3), last_longitude: longitude.rounded(toPlaces: 3), last_sync: NSDate().timeIntervalSince1970, monuments: self.monuments), to: .caches, as: "monuments.json")
			} catch let err {
				print("Error happened MM fetch: ", err)
				// if not working, there is an error while performing the request
			}
		}
	}
	
	func sort(accordingTo tags: [Tags]){
		// Return loaded monuments related to tags
	}
}
