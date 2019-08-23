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
	
	@Binding var monument: Monument?
	@Binding var show: Bool
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	
    var body: some View {
		NavigationView{
			List{
				MapDirectionsComponent(coords: locationManager.lastKnownLocation?.coordinate, monument: $monument)
					.frame(height: 420)
					.cornerRadius(10)
				
				monument!.description != nil ?
					Text(monument!.description!)
						.multilineTextAlignment(.leading)
				: nil
				
				monument!.illustration_data != nil ?
					Image(uiImage: UIImage(data: monument!.illustration_data!)!)
						.resizable()
						.scaledToFit()
						.cornerRadius(10)
				: nil
				
			}
				
			.navigationBarTitle(Text("Learn more about \(monument!.name)"), displayMode: .inline)
            .navigationBarItems(trailing: Button("OK"){
				self.presentationMode.wrappedValue.dismiss()
				//wip
				self.show = false
            })
		}
    }
}
