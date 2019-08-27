//
//  MonumentDetailsView.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 23/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct MonumentDetailsView: View {
	@EnvironmentObject var locationManager: LocationManager

	@Binding var monument: Monument
//	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	
    var body: some View {
		ScrollView{
			VStack{
				MapDirectionsComponent(coords: locationManager.lastKnownLocation?.coordinate, monument: $monument)
					.frame(height: 420)
					.cornerRadius(10)
					.padding(.top, 120)
				
				monument.description != nil ?
					Text(monument.description!)
						.multilineTextAlignment(.leading)
						.fixedSize(horizontal: false, vertical: true)
				: nil
				
				monument.illustration_data != nil ?
					Image(uiImage: UIImage(data: monument.illustration_data!)!)
						.resizable()
						.scaledToFit()
						.cornerRadius(10)
						.layoutPriority(1)
				: nil
			}
		}
		.navigationBarTitle(Text(monument.name))
		.padding()
		.padding(.bottom, 25)
		.background(LinearGradient(gradient: Gradient(colors: [.orange, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
		.edgesIgnoringSafeArea(.all)
		.accentColor(.orange)
    }
}
