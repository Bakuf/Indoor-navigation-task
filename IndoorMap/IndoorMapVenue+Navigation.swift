//
//  IndoorMapVenue+Extensions.swift
//  IndoorMap
//
//  Created by Andrew Hart on 13/10/2019.
//  Copyright © 2019 Dent Reality. All rights reserved.
//

import Foundation
import CoreLocation
import GameplayKit

extension IndoorMapVenue {
	func findRoute(from: IndoorMapUnit, to: IndoorMapUnit) -> [CLLocationCoordinate2D] {
        let coords = openings.map({ $0.coordinate })
        guard let fromOpening = from.getFirstEntry(from: coords), let toOpening = to.getFirstEntry(from: coords) else { return [] }
        return IndoorMapVenue.findPath(from: fromOpening, to: toOpening, coords: coords)
	}
}

extension IndoorMapVenue {
    
    static func findPath(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, coords: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        let myGraph = GKGraph()
        let nodes : [LocationNode] = coords.map({ LocationNode(coords: $0) })
        myGraph.add(nodes)
        for node in nodes {
            node.addConnections(to: nodes.filter({ $0 != node }), bidirectional: true)
        }
        guard let fromNode = nodes.first(where: { $0.coords == from }), let toNode = nodes.first(where: { $0.coords == to } ) else { return [] }
        let paths = myGraph.findPath(from: fromNode, to: toNode) as? [LocationNode]
        return paths?.map({ $0.coords }) ?? []
    }
    
    func findPathWithObstacles(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, coords: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        let myGraph = GKObstacleGraph(obstacles: obstacles, bufferRadius: 0.0)
        let nodes : [LocationNode] = coords.map({ LocationNode(coords: $0) })
        for node in nodes {
            var obstacle : [GKPolygonObstacle] = []
            if let obs = self.obstacle(for: node.coords),
                let foundObs = myGraph.obstacles.first(where: { $0.isEqual(to: obs) }) {
                obstacle.append(foundObs)
            }
            myGraph.connectUsingObstacles(node: node, ignoring: myGraph.obstacles)
        }
        guard let fromNode = nodes.first(where: { $0.coords == from }), let toNode = nodes.first(where: { $0.coords == to } ) else { return [] }
        let paths = myGraph.findPath(from: fromNode, to: toNode) as? [LocationNode]
        return paths?.map({ $0.coords }) ?? []
    }

}

extension GKPolygonObstacle {
    func isEqual(to: GKPolygonObstacle) -> Bool {
        guard vertexCount == to.vertexCount else { return false}
        var isEqual = true
        for x in 0...(vertexCount - 1) {
            if vertex(at: x) != to.vertex(at: x) {
                isEqual = false
                break
            }
        }
        return isEqual
    }
}

class LocationNode: GKGraphNode2D {
    
    internal init(coords: CLLocationCoordinate2D) {
        self.coords = coords
        super.init(point: vector_float2(x: Float(coords.latitude), y: Float(coords.longitude)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let coords: CLLocationCoordinate2D
    
    override func cost(to node: GKGraphNode) -> Float {
        guard let locationNode = node as? LocationNode else { return super.cost(to: node) }
        return Float(coords.distance(to: locationNode.coords))
    }
    
}
