//
//  StartNavigationButton.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 30/07/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct StartNavigationButton: View {
    var body: some View {
		ZStack{
			Rectangle()
				.frame(height: 50)
				.background(Color.black)
				.cornerRadius(10)
				.shadow(radius: 12)
			HStack{
				Image(systemName: "location.north") // map | mappin
				Text("Start lounging around")
			}
			.foregroundColor(Color.black)
			.font(.headline)
		}
    }
}

#if DEBUG
struct StartNavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        StartNavigationButton()
    }
}
#endif
