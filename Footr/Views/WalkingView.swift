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
	@State var selectedTags: [Tag]
	@Binding var expectedTime: Double
	
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
					.foregroundColor(.black)
			}
			.cornerRadius(10)
			.shadow(radius: 12)
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

#if DEBUG
struct WalkingView_Previews: PreviewProvider {
    static var previews: some View {
		WalkingView(selectedTags: [], expectedTime: .constant(120))
    }
}
#endif
