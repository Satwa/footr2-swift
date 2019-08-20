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

class TagsManager: NSObject, ObservableObject {
	@Published var tags: [Tags] = []
	
	func load(){
		// Load from cache

//		Storage.remove("tags.json", from: .caches)
		
		if Storage.fileExists("tags.json", in: .caches) {
			self.tags = Storage.retrieve("tags.json", from: .caches, as: [Tags].self)
		} else {
			print("Need to download tags")
			return download()
		}
	}
	
	fileprivate func download(){
		// Download function and save to cache
		Alamofire.request(API_ROOT + "tags").responseData { response in
			do {
				guard let data = response.result.value else { print("ERROR: no data in TM"); return }
				self.tags = try JSONDecoder().decode([Tags].self, from: data)
				
				// save to cache
				Storage.store(self.tags, to: .caches, as: "tags.json")
			} catch let err {
				print("Error happened TM fetch: ", err)
				// if not working, there is an error while performing the request
			}
		}
	}
}
