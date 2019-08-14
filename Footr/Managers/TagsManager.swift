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
		download()
	}
	
	fileprivate func download(){
		// Download function and save to cache
		Alamofire.request(API_ROOT + "tags").responseData { response in
			do {
				guard let data = response.result.value else { print("ERROR: no data in TM"); return }
				self.tags = try JSONDecoder().decode([Tags].self, from: data)
				print(self.tags)
				// save to cache
			} catch let err {
				print("Error happened TM fetch: ", err)
				// if not working, there is an error while performing the request
			}
		}
	}
}
