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
	}
	
	fileprivate func download(){
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
