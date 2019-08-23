//
//  MapSummaryComponent.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 18/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit
import Combine


struct MapSummaryComponent: UIViewRepresentable {
    var coords: CLLocationCoordinate2D?
    let mapDelegate = MapSummaryComponentDelegate()
	
	@Binding var timeRadius: Double
	var monuments: [Monument]
	@Binding var tags: [Tag]
	
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
		let radius: Double = Double(((5/3.6) * (timeRadius * 60)) / 2)
        view.tintColor = .orange
		view.delegate = mapDelegate
		view.showsTraffic = false
		
		let circleLocation = CLLocation(latitude: coords?.latitude ?? 0, longitude: coords?.longitude ?? 0)
		
		let selectedTags = tags.filter{ $0.selected ?? true }.map{ $0.filter_equivalence }.flatMap{ $0 }
		
		for monument in monuments {
			let annotation = MKPointAnnotation()
			annotation.title = monument.name.replacingOccurrences(of: "\\s?\\([\\w\\s]*\\)", with: "", options: .regularExpression) // wip: remove parentethis
			annotation.coordinate = CLLocationCoordinate2D(latitude: monument.latitude, longitude: monument.longitude)
			
			let annotationLocation = CLLocation(latitude: monument.latitude, longitude: monument.longitude)
			
			let includes = monument.filters.filter { selectedTags.contains($0) }
			
			if circleLocation.distance(from: annotationLocation) <= radius && includes.count > 0 {
				view.addAnnotation(annotation)
			}
		}
		
        let coordinate = CLLocationCoordinate2D(
			latitude: coords?.latitude ?? 0, longitude: coords?.longitude ?? 0)
		let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
		view.setRegion(region, animated: true)
		
        return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = true
		view.showsCompass = false
		view.delegate = mapDelegate
    }
}

class MapSummaryComponentDelegate: NSObject, MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		return MKOverlayRenderer(overlay: overlay)
	}

	func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
		for view in views {
			if view.annotation is MKUserLocation {
				view.canShowCallout = false
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		let coordinate = CLLocationCoordinate2D(
			latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
		let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
		mapView.setRegion(region, animated: true)
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let reuseIdentifier = "footrMapPin"
		var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
		
		if annotation is MKUserLocation {
			return nil
		}
		
		if #available(iOS 11.0, *) {
			if view == nil {
				view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
			}
			view?.displayPriority = .required
		} else {
			if view == nil {
				view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
			}
		}
		view?.annotation = annotation
		view?.canShowCallout = true
		return view
	}
}
