//
//  MapDirectionsComponent.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 23/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit
import Combine


struct MapDirectionsComponent: UIViewRepresentable {
    var coords: CLLocationCoordinate2D?
    let mapDelegate = MapDirectionsComponentDelegate()

	@Binding var monument: Monument
	
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.tintColor = .orange
		view.delegate = mapDelegate
		view.showsTraffic = false
		
		view.setUserTrackingMode(.followWithHeading, animated: true)
		
        let coordinate = CLLocationCoordinate2D(
			latitude: coords?.latitude ?? 0, longitude: coords?.longitude ?? 0)
		let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
		view.setRegion(region, animated: true)
		
        return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
		
		if view.annotations.filter({ $0.title == monument.name }).first == nil {
			view.removeAnnotations(view.annotations)
			view.removeOverlays(view.overlays)
			
			// Display annotation
			let annotation = MKPointAnnotation()
			annotation.title = monument.name.replacingOccurrences(of: "\\s?\\([\\w\\s]*\\)", with: "", options: .regularExpression) // wip: remove parenthesis
			annotation.coordinate = CLLocationCoordinate2D(latitude: monument.latitude, longitude: monument.longitude)
			view.addAnnotation(annotation)
			
			// Generate polyline
			let request = MKDirections.Request()
			request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: coords?.latitude ?? 0, longitude: coords?.longitude ?? 0), addressDictionary: nil))
			request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: monument.latitude, longitude: monument.longitude), addressDictionary: nil))
			request.requestsAlternateRoutes = true
			request.transportType = .walking

			let directions = MKDirections(request: request)

			directions.calculate { response, error in
				guard let unwrappedResponse = response else { return }
				
				for route in unwrappedResponse.routes {
					print(route.steps.map{ $0.instructions })
					view.addOverlay(route.polyline)
					view.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
				}
			}
		}
		
        view.showsUserLocation = true
		view.showsCompass = false
		view.delegate = mapDelegate
    }
}

class MapDirectionsComponentDelegate: NSObject, MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
		renderer.strokeColor = .orange
        return renderer
	}

	func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
		for view in views {
			if view.annotation is MKUserLocation {
				view.canShowCallout = false
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
		
//		let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//		let region = MKCoordinateRegion(center: mapView.centerCoordinate, span: span)
//
//		mapView.setRegion(region, animated: true)
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
