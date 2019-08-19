//
//  SummaryCardComponent.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 18/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct SummaryCardComponent: View {
	@State var title: String = "Time"
	@Binding var counter: String
	
    var body: some View {
        ZStack{
			Rectangle()
				.frame(height: 50)
				.background(Color.black)
				.cornerRadius(10)
				.shadow(radius: 12)
			
			VStack{
				Text(counter)
					.font(.title)
				Text(title)
					.font(.caption)
			}
			.padding()
			.foregroundColor(Color.black)
			.layoutPriority(1)
		}
    }
}

#if DEBUG
struct SummaryCardComponent_Previews: PreviewProvider {
    static var previews: some View {
		SummaryCardComponent(counter: .constant("0"))
    }
}
#endif
