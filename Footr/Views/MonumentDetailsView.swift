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
	
    var body: some View {
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
    }
}
