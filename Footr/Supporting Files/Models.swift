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
	var selected: Bool? = true // default (TODO: returns nil for now but should return true)
}

struct Monuments: Codable {
	var name: String
	var latitude: Double
	var longitude: Double
	var filters: [String]
	// TODO: description, illustration, category
}

struct CachedMonuments: Codable { // File cache conforms to this in theory
	var last_latitude: Double
	var last_longitude: Double
	var last_sync: Double
	var monuments: [Monuments]
}
