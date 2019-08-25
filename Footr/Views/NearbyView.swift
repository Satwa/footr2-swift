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
	@State var tags: [Tag] = []
        
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
				

				MapComponent(coords: locationManager.lastKnownLocation?.coordinate, timeRadius: $expectedTime, monuments: locationManager.monumentsManager.monuments, tags: $tags)
					.cornerRadius(10)
					.shadow(radius: 12)
					.padding(.top)
					.padding(.bottom)
					.frame(minHeight: 0, maxHeight: .infinity) // used to be 300
				
				HStack{
					Text("Expected time of your walk").bold()
					Spacer()
				}
				
				HStack{
					Slider(value: $expectedTime, in: 15...120, step: 5) //
					Text("\(Int(expectedTime)) minutes")
				}

				ScrollView (.horizontal, showsIndicators: false) {
					 HStack {
						ForEach(0..<tags.count){ i in
							TagButtonComponent(tag: self.$tags.element(i))
								.onTapGesture {
//									print(self.$tags[i].selected)
									self.tags[i].selected = ((self.tags[i].selected ?? true) ? false : true)
								}
						}
					 }
				}
				.frame(height: 100)
				.padding(.top, 10)
				.padding(.bottom, 20)
				
				NavigationLink(destination: SummaryView(selectedTags: self.tags.filter{ $0.selected ?? true }, expectedTime: $expectedTime)){
					StartNavigationButton()
				}
				
			}
			.padding()
			.padding(.bottom, 25)
			.background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
			.edgesIgnoringSafeArea(.all)
		}
		.foregroundColor(.white)
		.accentColor(.white)
		.onAppear{
			self.tags = self.locationManager.tagsManager.tags
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
