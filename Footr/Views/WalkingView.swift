//
//  WalkingView.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 18/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct WalkingView: View {
	@EnvironmentObject var locationManager: LocationManager
	@State var selectedTags: [Tags]
	@Binding var expectedTime: Double
	
    var body: some View {
        VStack{
			MapSummaryComponent(coords: locationManager.lastKnownLocation?.coordinate, timeRadius: $expectedTime, monuments: locationManager.monuments, tags: $selectedTags)
				.cornerRadius(10)
				.shadow(radius: 12)
				.padding(.top, 100)
				.padding(.bottom)
				.frame(minHeight: 0, maxHeight: .infinity) // used to be 300
				
			HStack{
				SummaryCardComponent(title: "Time", counter: .constant("12"))
				SummaryCardComponent(title: "Steps", counter: .constant("850"))
			}

			HStack{
				SummaryCardComponent(title: "Alert", counter: .constant("8"))
				SummaryCardComponent(title: "Done", counter: .constant("-1"))
			}
		}
		.padding()
		.padding(.bottom, 25)
		.background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
		.edgesIgnoringSafeArea(.all)
		.foregroundColor(.white)
		.accentColor(.white)
		.onAppear(){
			self.locationManager.notificationsManager.askForPermission()
			self.locationManager.startUpdatingInBackground()
			self.locationManager.startedLounging = true
			self.locationManager.selectedTags = self.selectedTags
		}
		.onDisappear(){
			self.locationManager.stopUpdatingInBackground()
			self.locationManager.startedLounging = false
			self.locationManager.notificationsManager.cancelNotifications()
		}
	}
}
