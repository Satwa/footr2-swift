//
//  ContentView.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 30/07/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI
import CoreLocation

struct NearbyView: View {
    
    @EnvironmentObject var locationManager: LocationManager
	@State var expectedTime: Double = 30
	@State var selectedTags: Int = 15
        
    var body: some View {
		NavigationView{
			VStack{
				HStack{
					Group{
						Text(locationManager.cityName ?? "City")
							.bold()
						Spacer()
						Text(locationManager.weather ?? "22°C")
							.bold()
					}
					.font(.headline)
				}
				.padding(.top, 25)
				

				MapComponent(coords: locationManager.lastKnownLocation?.coordinate, timeRadius: $expectedTime)
					.cornerRadius(10)
					.shadow(radius: 12)
					.padding(.top)
					.padding(.bottom)
					.frame(minHeight: 300)
				
				HStack{
					Text("Expected time of your walk").bold()
					Spacer()
				}
				
				HStack{
					Slider(value: $expectedTime, in: 15...120, step: 5) //
					Text("\(Int(expectedTime)) minutes")
				}

				HStack{
					Button("Select tags"){
						print("WIP")
					}
					Spacer()
					Text("\(selectedTags) tags selected")
				}
				.padding(.top, 5)
				.padding(.bottom, 55)
				
				NavigationLink(destination: Text("WIP")){
					StartNavigationButton()
				}
			}
			.padding()
			.padding(.bottom, 25)
			.background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
			.edgesIgnoringSafeArea(.all)
			.foregroundColor(.white)
			.accentColor(.white)
		}
    }
}

#if DEBUG
struct NearbyView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyView()
    }
}
#endif
