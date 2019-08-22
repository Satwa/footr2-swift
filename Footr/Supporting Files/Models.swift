//
//  Models.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 14/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

struct Tag: Codable {
	var slug: String
	var name: String
	var filter_equivalence: [String]
	var selected: Bool? = true // default
}

struct Coordinate: Codable{
	var latitude: Double
	var longitude: Double
}

class Monument: Codable, Identifiable {
	var id: String
	var name: String
	var latitude: Double
	var longitude: Double
	var filters: [String]
	var description: String?
	var illustration: String? {
		didSet(illustration){
			if let url = URL(string: illustration ?? "") {
				URLSession.shared.dataTask(with: url){ (data,_,_) in
					if let data = data {
						print("model - image data found")
						DispatchQueue.main.async {
							self.illustration_data = data
						}
					}
				}.resume()
			}
		}
	}
	var illustration_data: Data?
	
	var ignored: Bool? = false
	var announced: Bool? = false
	var followed: Bool? = true
}

struct CachedMonuments: Codable { // Cache file conforms to this in theory
	var last_latitude: Double
	var last_longitude: Double
	var last_sync: Double
	var monuments: [Monument]
}

struct Walk: Codable{
	var startedAt = Date.timeIntervalSinceReferenceDate
	var latitude: Double
	var longitude: Double
	var monuments: [Monument]
	var positions: [Coordinate]
	var stopped: Bool = false
}

struct WalksHistory: Codable{
	var walks: [Walk]
}
