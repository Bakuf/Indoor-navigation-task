//
//  IndoorMapTests.swift
//  IndoorMapTests
//
//  Created by Rodrigo Galvez on 20/06/2023.
//  Copyright © 2023 Dent Reality. All rights reserved.
//

import XCTest
import CoreLocation
import GameplayKit
@testable import IndoorMap

final class IndoorMapTests: XCTestCase {

    func testPathFinder() throws {
        let path =
        [
            CLLocationCoordinate2D(latitude: 51.52471357679181, longitude: -0.04063115374217572),
            CLLocationCoordinate2D(latitude: 51.52482779729118, longitude: -0.04061913951189898),
            CLLocationCoordinate2D(latitude: 51.524854072321965, longitude: -0.04055815937418953),
            CLLocationCoordinate2D(latitude: 51.52479274068589, longitude: -0.0405601982138011),
            CLLocationCoordinate2D(latitude: 51.5246736349304, longitude: -0.040570092509774926)
        ]
        let route = IndoorMapVenue.findPath(from: path[1], to: path[3], coords: path)
        XCTAssert(route.count != 0)
    }
    
    func testGKPolygonObstacleEquality() throws {
        let obstacle1 = GKPolygonObstacle(points: [SIMD2(x: 51.52471357679181, y: -0.04063115374217572)])
        let obstacle2 = GKPolygonObstacle(points: [SIMD2(x: 51.52471357679181, y: -0.04063115374217572)])
        XCTAssertFalse(obstacle1 == obstacle2)
        XCTAssert(obstacle1.isEqual(to: obstacle2))
    }

}
