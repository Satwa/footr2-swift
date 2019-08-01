//
//  MapComponent.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 30/07/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit
import Combine


struct MapComponent: UIViewRepresentable {
    var coords: CLLocationCoordinate2D? // TODO: Replace by @Binding
    let mapDelegate = MapComponentDelegate()
	
	@Binding var timeRadius: Double
	
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
		view.delegate = mapDelegate
        view.tintColor = .orange
		
        return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
		let radius: Double = Double(Int(((5/3.6) * (timeRadius * 60)) / 2))
        view.showsUserLocation = true
		
		view.removeOverlays(view.overlays)
		view.addOverlay(MKCircle(center: coords ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: radius as CLLocationDistance))
		
        let coordinate = CLLocationCoordinate2D(
            latitude: coords?.latitude ?? 0, longitude: coords?.longitude ?? 0)
		let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
		view.setRegion(region, animated: true)
    }
}

class MapComponentDelegate: NSObject, MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let overlay = overlay as? MKCircle {
			let circleRenderer = MKCircleRenderer(overlay: overlay)
			
			circleRenderer.fillColor = UIColor.init(named: "footrPink")!.withAlphaComponent(0.3)
			circleRenderer.strokeColor = UIColor.init(named: "footrOrange")!
			circleRenderer.lineWidth = 2
			
			return circleRenderer
		}
		return MKOverlayRenderer(overlay: overlay)
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		if let _ = view.annotation!.title {
			view.canShowCallout = false
		}
	}
}
