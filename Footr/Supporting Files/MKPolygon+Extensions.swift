//
//  MKPolygon+Extensions.swift
//  Footr
//
//  Created by Joshua Tabakhoff on 15/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import Foundation
import CoreGraphics
import MapKit

extension MKPolygon {

    func isCoordinateInsidePolyon(coordinate: CLLocationCoordinate2D) -> Bool {

        var inside = false

        let polygonRenderer = MKPolygonRenderer(polygon: self)
		let currentMapPoint: MKMapPoint = MKMapPoint(coordinate)
		let polygonViewPoint: CGPoint = polygonRenderer.point(for: currentMapPoint)

		if polygonRenderer.path.contains(polygonViewPoint) {
			inside = true
		}
		
//        if CGPathContainsPoint(polygonRenderer.path, nil, polygonViewPoint, true) {
//            inside = true
//        }

        return inside
    }
}
