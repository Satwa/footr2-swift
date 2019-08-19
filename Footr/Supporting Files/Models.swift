//
//  Models.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 14/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import Foundation

struct Tags: Codable {
	var slug: String
	var name: String
	var filter_equivalence: [String]
	var selected: Bool? = true // default
}

struct Monuments: Codable {
	var name: String
	var latitude: Double
	var longitude: Double
	var filters: [String]
	var description: String?
	var illustration: String?
	
	var ignored: Bool? = false
	var announced: Bool? = false
	var followed: Bool? = true
}

struct CachedMonuments: Codable { // Cache file conforms to this in theory
	var last_latitude: Double
	var last_longitude: Double
	var last_sync: Double
	var monuments: [Monuments]
}
