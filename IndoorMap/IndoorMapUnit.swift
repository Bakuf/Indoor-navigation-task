//
//  IndoorMapUnit.swift
//  IndoorMap
//
//  Created by Andrew Hart on 13/10/2019.
//  Copyright © 2019 Dent Reality. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class IndoorMapUnit {
	enum Category {
		case room
		case hallway
	}
	
	var id = UUID().uuidString
	
	///Unit boundary. Last coordinate is the same as the first coordinate
	var coordinates = [CLLocationCoordinate2D]()
	
	var category: Category
	
	init(coordinates: [CLLocationCoordinate2D], category: Category) {
		self.coordinates = coordinates
		self.category = category
	}
}

extension IndoorMapUnit {
    
    func getFirstEntry(from entries: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
        let polygonRenderer = MKPolygonRenderer(polygon: UnitOverlay(unit: self))
        for entry in entries {
            let mapPoint: MKMapPoint = MKMapPoint(entry)
            let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)
            if polygonRenderer.path.contains(polygonViewPoint) {
                return entry
            }
        }
        return nil
    }
    
    func contains(coords: CLLocationCoordinate2D) -> Bool {
        let polygonRenderer = MKPolygonRenderer(polygon: UnitOverlay(unit: self))
        let mapPoint: MKMapPoint = MKMapPoint(coords)
        let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)
        return polygonRenderer.path.contains(polygonViewPoint)
    }
    
}
