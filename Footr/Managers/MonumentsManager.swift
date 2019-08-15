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
	
	func load(){
		// Load from cache or download
//		download()
		
		// NSDate().timeIntervalSince1970
		if Storage.fileExists("monuments.json", in: .caches) {
			let cache = Storage.retrieve("monuments.json", from: .caches, as: CachedMonuments.self)
			self.monuments = cache.monuments
		} else {
			print("Need to download monuments")
			return download()
		}
	}
	
	fileprivate func download(){ // TODO: Put the correct latitude & longitude
		// Download function and save to cache
		Alamofire.request(
			API_ROOT + "monuments",
			method: .post,
			parameters: ["latitude": 48.87603, "longitude": 2.35036]
		).responseData { response in
			do {
				guard let data = response.result.value else { print("ERROR: no data in MM"); return }
				self.monuments = try JSONDecoder().decode([Monuments].self, from: data)
				
				// save to cache
				Storage.store(CachedMonuments(last_latitude: 48.87603, last_longitude: 2.35036, last_sync: NSDate().timeIntervalSince1970, monuments: self.monuments), to: .caches, as: "monuments.json")
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
