//
//  HistoryManager.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 22/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

// TODO: Don't edit a walk marked as stopped
// TODO: Monitor visited too (<50m from place)
// TODO: Calculate duration from startedAt to stoppedAt
// TODO: Sauvegarder polyline?

class HistoryManager: NSObject, ObservableObject {
	internal let objectWillChange = ObservableObjectPublisher()
	@Published var history: WalksHistory = WalksHistory(walks: [])
	@Published var currentWalk: Walk = Walk(latitude: 0, longitude: 0, monuments: [], positions: [])
	
	var lastStartedWalkInMemory: Double = 0
	
	override init(){
		super.init()
		
		if Storage.fileExists("history.json", in: .documents) {
			self.history = Storage.retrieve("history.json", from: .documents, as: WalksHistory.self)
			popEmptyWalks()
		} else {
			print("History file missing")
		}
	}
	
	func manipulateMonument(monument: Monument){ // wip
		if lastStartedWalkInMemory != 0 {
			if ((history.walks.first(where: { $0.startedAt == self.lastStartedWalkInMemory })?.monuments.first(where: { $0.name == monument.name })) != nil) {
				// Monument found in walk
				guard let walk_index = history.walks.firstIndex(where: { $0.startedAt == self.lastStartedWalkInMemory }) else {
					print("walk not found")
					return
				}
				
				guard let monument_index = history.walks[walk_index].monuments.firstIndex(where: { $0.name == monument.name }) else {
					print("monument not found")
					return
				}
				
				history.walks[walk_index].monuments[monument_index] = monument
				currentWalk.monuments[monument_index] = monument
			} else {
				// Monument need to monument
				guard let walk_index = history.walks.firstIndex(where: { $0.startedAt == self.lastStartedWalkInMemory }) else {
					print("walk not found")
					return
				}
				
				history.walks[walk_index].monuments.append(monument)
				currentWalk.monuments.append(monument)
			}
			
			save()
		}else{
			print("error happened: no walk in memory")
		}
	}
	
	func markLastAsStopped(){ // wip
		if lastStartedWalkInMemory != 0 {
			guard let walk_index = history.walks.firstIndex(where: { $0.startedAt == self.lastStartedWalkInMemory }) else {
				print("walk not found")
				return
			}
			
			history.walks[walk_index].stopped = true
			history.walks[walk_index].stoppedAt = Date.timeIntervalSinceReferenceDate
			currentWalk.stopped = true
			currentWalk.stoppedAt = history.walks[walk_index].stoppedAt
			
			save()
		}else{
			print("error happened: no walk in memory")
		}
	}
	
	func addWalk(latitude: Double, longitude: Double){ // TODO: When adding walk, schedule notification back to home
		self.lastStartedWalkInMemory = Date.timeIntervalSinceReferenceDate
		history.walks.append(Walk(startedAt: self.lastStartedWalkInMemory, latitude: latitude, longitude: longitude, monuments: [], positions: [Coordinate(latitude: latitude, longitude: longitude)]))
		currentWalk = history.walks.last!
		
		save()
	}
	
	func getLastPosition() -> Coordinate? {
		if lastStartedWalkInMemory != 0 {
			guard let walk_index = history.walks.firstIndex(where: { $0.startedAt == self.lastStartedWalkInMemory }) else {
				print("walk not found")
				return nil
			}
			
			return history.walks[walk_index].positions.last
		}else{
			print("error happened: no walk in memory")
			return nil
		}
	}
	
	func addPosition(location: CLLocationCoordinate2D){ // TODO: Save only every 30 meters
		if lastStartedWalkInMemory != 0 {
			guard let walk_index = history.walks.firstIndex(where: { $0.startedAt == self.lastStartedWalkInMemory }) else {
				print("walk not found")
				return
			}
			
			history.walks[walk_index].positions.append(Coordinate(latitude: location.latitude, longitude: location.longitude))
			currentWalk.positions.append(Coordinate(latitude: location.latitude, longitude: location.longitude))
			
			save()
		}else{
			print("error happened: no walk in memory")
		}
	}
	
	fileprivate func popEmptyWalks(){
		self.history.walks.removeAll(where: { $0.monuments.count == 0 })
		save()
	}
	
	fileprivate func save(){
		Storage.store(self.history, to: .documents, as: "history.json")
//		print(self.history)
//		self.objectWillChange.send()
	}
}
