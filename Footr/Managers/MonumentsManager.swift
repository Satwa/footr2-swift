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
	internal let objectWillChange = ObservableObjectPublisher()
	@Published var monuments: [Monument] = []
	@Published var selectedMonument: Monument? = nil
	
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
			
			for i in 0..<self.monuments.count{
				self.monuments[i].illustration = self.monuments[i].illustration
			}
			
			self.objectWillChange.send() //while this is still buggy
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
				self.monuments = try JSONDecoder().decode([Monument].self, from: data)
				
				for i in 0..<self.monuments.count{
					self.monuments[i].illustration = self.monuments[i].illustration
				}
				
				self.objectWillChange.send() //while this is still buggy
				// save to cache
				self.save(latitude: latitude, longitude: longitude)
			} catch let err {
				print("Error happened MM fetch: ", err)
				// if not working, there is an error while performing the request
			}
		}
	}
	
	fileprivate func save(latitude: Double, longitude: Double){
		let _monuments = monuments
		
		for i in 0..<_monuments.count{
			_monuments[i].announced = false
			_monuments[i].followed = false
			_monuments[i].ignored = false
		}
		
		Storage.store(CachedMonuments(last_latitude: latitude.rounded(toPlaces: 3), last_longitude: longitude.rounded(toPlaces: 3), last_sync: NSDate().timeIntervalSince1970, monuments: _monuments), to: .caches, as: "monuments.json")
	}
	
	func sort(accordingTo tags: [Tag]){
		// Return loaded monuments related to tags
	}
	
	func markAsAnnounced(idx: Int){
		self.monuments[idx].announced = true
		self.objectWillChange.send() //while this is still buggy
	}
	
	
	
	func markAsFollowed(idx: Int){
		self.monuments[idx].followed = true
		self.objectWillChange.send() //while this is still buggy
	}
	
	func markAsFollowed(name: String){
		self.monuments.first{ $0.name == name }?.followed = true
		self.objectWillChange.send() //while this is still buggy
	}
	
	
	
	func markAsIgnored(idx: Int){
		self.monuments[idx].ignored = true
		self.objectWillChange.send() //while this is still buggy
	}
	
	func markAsIgnored(name: String){
		self.monuments.first{ $0.name == name }?.ignored = true
		self.objectWillChange.send() //while this is still buggy
	}
}
