//
//  TagButtonComponent.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 15/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct TagButtonComponent: View {
	@State var tag: Tags
	
    var body: some View {
        ZStack{
			Rectangle()
				.frame(height: 40)
				.cornerRadius(10)
				.opacity((tag.selected ?? true) ? 1.0 : 0.8)

			Text(tag.name)
				.padding()
				.foregroundColor(.black)
				.font(.headline)
				.layoutPriority(1)
		}
		.onAppear(){
			print(self.tag)
		}
//		.onTapGesture {
//			if let _ = self.tag.selected {
//				self.tag.selected?.toggle()
//			} else{
//				self.tag.selected = false
//			}
//		}
    }
}
