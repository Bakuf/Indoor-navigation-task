//
//  IndoorMapVenue.swift
//  IndoorMap
//
//  Created by Andrew Hart on 13/10/2019.
//  Copyright © 2019 Dent Reality. All rights reserved.
//

import Foundation
import GameplayKit
import CoreLocation

class IndoorMapVenue {
	var units = [IndoorMapUnit]()
	var openings = [IndoorMapOpening]()
}

extension IndoorMapVenue {
    
    var obstacles : [GKPolygonObstacle] {
        let roomUnits = units.filter({ $0.category == .room })
        return roomUnits.map( { GKPolygonObstacle(points: $0.coordinates.map({ $0.asSIMD2 })) } )
    }
    
    func obstacle(for opening: CLLocationCoordinate2D) -> GKPolygonObstacle? {
        if let unit = units.filter({ $0.category == .room }).first(where: { $0.contains(coords: opening) }) {
            return GKPolygonObstacle(points: unit.coordinates.map({ $0.asSIMD2 }))
        }
        return nil
    }
    
}
