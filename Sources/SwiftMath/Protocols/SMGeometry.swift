//
//  File.swift
//  
//
//  Created by Andre Pham on 22/1/2024.
//

import Foundation

public protocol SMGeometry {
    
    /// This geometry's vertices (ordered)
    var vertices: [SMPoint] { get }
    /// This geometry's edges (ordered)
    var edges: [SMLineSegment] { get }
    
    func translate(by point: SMPoint)
    func rotate(around center: SMPoint, by angle: SMAngle)
    func scale(from point: SMPoint, by factor: Double)
    
}
extension SMGeometry {
    
    public var minXPoint: SMPoint? {
        return self.vertices.min(by: { $0.x < $1.x })
    }
    public var minYPoint: SMPoint? {
        return self.vertices.min(by: { $0.y < $1.y })
    }
    public var maxXPoint: SMPoint? {
        return self.vertices.max(by: { $0.x < $1.x })
    }
    public var maxYPoint: SMPoint? {
        return self.vertices.max(by: { $0.y < $1.y })
    }
    public var minX: Double? {
        return self.minXPoint?.x
    }
    public var maxX: Double? {
        return self.maxXPoint?.x
    }
    public var minY: Double? {
        return self.minYPoint?.y
    }
    public var maxY: Double? {
        return self.maxYPoint?.y
    }
    public var boundingBox: SMRect? {
        guard let minX, let minY, let maxX, let maxY else {
            return nil
        }
        return SMRect(
            origin: SMPoint(x: minX, y: minY),
            end: SMPoint(x: maxX, y: maxY)
        )
    }
    public var averagePoint: SMPoint? {
        guard !self.vertices.isEmpty else {
            return nil
        }
        return SMPoint(
            x: self.vertices.map({ $0.x }).reduce(0.0, +)/Double(self.vertices.count),
            y: self.vertices.map({ $0.y }).reduce(0.0, +)/Double(self.vertices.count)
        )
    }
    
    public func boundingBoxContains(point: SMPoint) -> Bool {
        guard let boundingBox else {
            return false
        }
        return boundingBox.contains(point: point)
    }
    
    public func boundingBoxEncloses(point: SMPoint) -> Bool {
        guard let boundingBox else {
            return false
        }
        return boundingBox.encloses(point: point)
    }
    
    public func boundingBoxContainsBoundingBox(of geometry: SMGeometry) -> Bool {
        guard let boundingBox, let geometryBoundingBox = geometry.boundingBox else {
            return false
        }
        return boundingBox.contains(rect: geometryBoundingBox)
    }
    
    public func boundingBoxEnclosesBoundingBox(of geometry: SMGeometry) -> Bool {
        guard let boundingBox, let geometryBoundingBox = geometry.boundingBox else {
            return false
        }
        return boundingBox.encloses(rect: geometryBoundingBox)
    }
    
    public func boundingBoxContains(geometry: SMGeometry) -> Bool {
        guard let boundingBox else {
            return false
        }
        return boundingBox.contains(geometry: geometry)
    }
    
    public func boundingBoxEncloses(geometry: SMGeometry) -> Bool {
        guard let boundingBox else {
            return false
        }
        return boundingBox.encloses(geometry: geometry)
    }
    
    public func boundingBoxIntersects(point: SMPoint) -> Bool {
        guard let boundingBox else {
            return false
        }
        return boundingBox.intersects(point: point)
    }
    
    public func boundingBoxIntersectsBoundingBox(of geometry: SMGeometry) -> Bool {
        guard let boundingBox, let geometryBoundingBox = geometry.boundingBox else {
            return false
        }
        return boundingBox.intersects(with: geometryBoundingBox)
    }
    
    public func boundingBoxIntersects(geometry: SMGeometry) -> Bool {
        guard let boundingBox else {
            return false
        }
        return boundingBox.intersects(geometry: geometry)
    }
    
    public func boundingBoxRelatesToBoundingBox(of geometry: SMGeometry) -> Bool {
        guard let boundingBox, let geometryBoundingBox = geometry.boundingBox else {
            return false
        }
        return boundingBox.relates(to: geometryBoundingBox)
    }
    
    /// Checks if a point intersects any of this geometry's edges.
    /// - Parameters:
    ///   - point: The point to check for intersection
    /// - Returns: True if the point intersects any of this geometry's edges
    public func intersects(point: SMPoint) -> Bool {
        for edge in self.edges {
            if edge.intersects(point: point) {
                return true
            }
        }
        return false
    }
    
    /// Checks if there is an intersecting point between two geometries (doesn't count overlapping edges).
    /// - Parameters:
    ///   - geometry: The other geometry to check
    /// - Returns: True if the geometries intersect
    public func intersects(geometry: SMGeometry) -> Bool {
        guard self.boundingBoxRelatesToBoundingBox(of: geometry) else {
            return false
        }
        for edge in self.edges {
            for otherEdge in geometry.edges {
                if edge.intersects(line: otherEdge) {
                    return true
                }
            }
        }
        return false
    }
    
    /// Checks if this geometry has some spatial relationship (intersection, containment, overlap, etc.) with other geometry.
    /// - Parameters:
    ///   - geometry: The other geometry to compare against
    /// - Returns: True if the two geometries are spatially related
    public func relates(to geometry: SMGeometry) -> Bool {
        guard self.boundingBoxRelatesToBoundingBox(of: geometry) else {
            return false
        }
        if self.intersects(geometry: geometry) {
            return true
        }
        for edge in self.edges {
            for otherEdge in geometry.edges {
                if edge.overlaps(with: otherEdge) {
                    return true
                }
            }
        }
        return false
    }
    
    /// Checks if all edges and points in this geometry is shared by another geometry
    /// - Parameters:
    ///   - geometry: The other geometry to compare against
    /// - Returns: True if both geometries are equivalent by comparison of points
    public func matchesGeometry(of geometry: SMGeometry) -> Bool {
        guard self.vertices.count == geometry.vertices.count else {
            return false
        }
        if self.vertices.count == 1 {
            return self.vertices.first! == geometry.vertices.first!
        }
        let sortedFromBottomLeft = self.vertices.sorted(by: { $0.x < $1.x }).sorted(by: { $0.y < $1.y })
        let comparison = geometry.vertices.sorted(by: { $0.x < $1.x }).sorted(by: { $0.y < $1.y })
        guard sortedFromBottomLeft == comparison else {
            return false
        }
        // At this stage, every point in this geometry exists in the other geometry, and vice versa
        var matchingEdgeIndices = [Int]()
        // It's known the number of edges is greater than 0, since we check if there's only one vertex and both geometries have the same number of vertices
        let edges = self.edges
        let otherEdges = geometry.edges
        for (otherEdgeIndex, otherEdge) in otherEdges.enumerated() {
            if edges[0].matchesGeometry(of: otherEdge) {
                matchingEdgeIndices.append(otherEdgeIndex)
            }
        }
        for otherEdgeIndex in matchingEdgeIndices {
            var allMatch = true
            for index in 0..<self.vertices.count - 1 {
                if !edges[index].matchesGeometry(of: otherEdges[(index + otherEdgeIndex)%self.vertices.count]) {
                    allMatch = false
                }
            }
            if allMatch {
                return true
            }
        }
        // If the edges are reversed
        for otherEdgeIndex in matchingEdgeIndices {
            var allMatch = true
            for index in 0..<self.vertices.count - 1 {
                var matchingIndex = (otherEdgeIndex - index)%self.vertices.count
                if matchingIndex < 0 {
                    matchingIndex += self.vertices.count
                }
                if !edges[index].matchesGeometry(of: otherEdges[matchingIndex]) {
                    allMatch = false
                }
            }
            if allMatch {
                return true
            }
        }
        return false
    }
    
}
