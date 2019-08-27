//
//  MonumentRowComponent.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 27/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct MonumentRowComponent: View {
	@Binding var monument: Monument
	
    var body: some View {
		NavigationLink(destination: MonumentDetailsView(monument: $monument)){
			Text(monument.name)
				.foregroundColor((monument.ignored ?? false) ? .gray : .black)
		}
    }
}
