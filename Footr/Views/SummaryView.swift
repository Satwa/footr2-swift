//
//  WalkingView.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 18/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct SummaryView: View {
	@EnvironmentObject var locationManager: LocationManager
	@State var selectedTags: [Tag]
	@Binding var expectedTime: Double

	@State var showAnyMonument: Bool = false
	
    var body: some View {
        VStack{
			MapSummaryComponent(coords: locationManager.lastKnownLocation?.coordinate, timeRadius: $expectedTime, monuments: locationManager.monumentsManager.monuments, tags: $selectedTags)
				.cornerRadius(10)
				.shadow(radius: 12)
				.padding(.top, 100)
				.padding(.bottom)
				.frame(minHeight: 0, maxHeight: .infinity)
			

			List(locationManager.monumentsManager.monuments.filter({ $0.announced ?? false })){ monument in
				Text(monument.name)
					.foregroundColor((monument.ignored ?? false) ? .gray : .black)
					.onTapGesture {
						self.locationManager.monumentsManager.selectedMonument = self.locationManager.monumentsManager.monuments.first{ $0.name == monument.name }
						self.showAnyMonument = true
					}
			}
			.cornerRadius(10)
			.shadow(radius: 12)
			.sheet(isPresented: $showAnyMonument){
				MonumentDetailsView(monument: self.$locationManager.monumentsManager.selectedMonument).environmentObject(self.locationManager)
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.navigationBarHidden(true)
		.padding()
		.padding(.bottom, 25)
		.background(LinearGradient(gradient: Gradient(colors: [.orange, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
		.edgesIgnoringSafeArea(.all)
		.onAppear{
			self.locationManager.notificationsManager.askForPermission()
			self.locationManager.startUpdatingInBackground()
			
			if !self.locationManager.startedLounging { // add a new walk only if none is currently happening
				self.locationManager.historyManager.addWalk(latitude: self.locationManager.lastKnownLocation!.coordinate.latitude, longitude: self.locationManager.lastKnownLocation!.coordinate.longitude)
			}
			
			self.locationManager.startedLounging = true
			self.locationManager.selectedTags = self.selectedTags
		}
		.onDisappear{
			// in fact, when going to background, this code may be called so for now just comment it (even if it's broken atm)
//			self.locationManager.stopUpdatingInBackground()
//			self.locationManager.startedLounging = false
//			self.locationManager.notificationsManager.cancelNotifications()
			print("onDisappear")
		}
	}
}
