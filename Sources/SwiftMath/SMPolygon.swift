//
//  SMPolygon.swift
//
//
//  Created by Andre Pham on 19/1/2024.
//

import Foundation
import CoreGraphics

/// Represents a polygon.
/// A closed shape made of straight edges.
public struct SMPolygon: SMMutableGeometry {
    
    /// This geometry's vertices (ordered)
    public var vertices = [SMPoint]()
    /// This geometry's edges (ordered)
    public var edges: [SMLineSegment] {
        guard self.vertices.count > 1 else {
            return []
        }
        var result = [SMLineSegment]()
        for index in self.vertices.indices.dropLast() {
            result.append(SMLineSegment(origin: self.vertices[index], end: self.vertices[index + 1]))
        }
        result.append(SMLineSegment(origin: self.vertices.last!, end: self.vertices.first!))
        return result
    }
    public var isValid: Bool {
        // Must at least be a triangle
        guard self.vertices.count > 2 else {
            return false
        }
        let edges = self.edges
        if !edges.allSatisfy({ $0.isValid }) {
            // One or more edges are invalid
            return false
        }
        for index1 in edges.indices {
            for index2 in edges.indices {
                guard index1 != index2 else {
                    continue
                }
                let edgesAreAdjacent = abs(index1 - index2) == 1 || abs(index1 - index2) == (edges.count - 1)
                let edge1 = edges[index1]
                let edge2 = edges[index2]
                if !edgesAreAdjacent && edge1.intersects(line: edge2) {
                    // Edges are not adjacent yet they intersect
                    return false
                }
                if edge1.overlaps(with: edge2) {
                    // Edges overlap
                    return false
                }
            }
        }
        return true
    }
    public var area: Double? {
        guard self.isValid else {
            return nil
        }
        // Shoelace formula
        var sum = 0.0
        for i in self.vertices.indices {
            let current = self.vertices[i]
            let next = self.vertices[(i + 1)%self.vertices.count]
            sum += (current.x * next.y) - (next.x * current.y)
        }
        // Closing the loop: adding the product of the last and the first point
        let last = self.vertices.last!
        let first = self.vertices.first!
        sum += (last.x * first.y) - (first.x * last.y)
        return 0.5 * abs(sum)
    }
    public var perimeter: Double? {
        guard self.isValid else {
            return nil
        }
        var totalLength = self.vertices.last!.length(to: self.vertices.first!)
        for index in self.vertices.indices.dropLast() {
            totalLength += self.vertices[index].length(to: self.vertices[index + 1])
        }
        return totalLength
    }
    public var isClockwise: Bool {
        // https://stackoverflow.com/a/1165943
        return (self.edges.reduce(0.0, { $0 + ($1.end.x - $1.origin.x) * ($1.end.y + $1.origin.y) })).isGreaterThanZero()
    }
    public var isAnticlockwise: Bool {
        // https://stackoverflow.com/a/1165943
        return (self.edges.reduce(0.0, { $0 + ($1.end.x - $1.origin.x) * ($1.end.y + $1.origin.y) })).isLessThanZero()
    }
    
    // MARK: - Constructors
    
    public init(vertices: [SMPoint]) {
        self.vertices = vertices
    }
    
    public init(vertices: SMPoint...) {
        self.init(vertices: vertices)
    }
    
    // MARK: - Functions
    
    /// Checks if the polygon contains a point (a point exists inside or on the edge of the polygon).
    /// - Parameters:
    ///   - point: The point being checked if it's contained
    ///   - validatePolygon: If set to true, polygons that are invalid will return false
    /// - Returns: True if the point is within or on the edge of the polygon
    public func contains(point: SMPoint, validatePolygon: Bool = false) -> Bool {
        guard !validatePolygon || self.isValid else {
            return false
        }
        guard self.boundingBoxContains(point: point) else {
            return false
        }
        for edge in self.edges {
            if edge.intersects(point: point) {
                return true
            }
        }
        return self.pnpoly(point)
    }
    
    /// Checks if the polygon encloses a point (a point exists inside and not on the edge nor outside polygon).
    /// - Parameters:
    ///   - point: The point being checked if it's enclosed
    ///   - validatePolygon: If set to true, polygons that are invalid will return false
    /// - Returns: True if the point is within the polygon
    public func encloses(point: SMPoint, validatePolygon: Bool = false) -> Bool {
        guard !validatePolygon || self.isValid else {
            return false
        }
        guard self.boundingBoxEncloses(point: point) else {
            return false
        }
        for edge in self.edges {
            if edge.intersects(point: point) {
                return false
            }
        }
        return self.pnpoly(point)
    }
    
    /// Checks if the polygon contains some geometry (the geometry exists inside or on the edge of the polygon).
    /// - Parameters:
    ///   - geometry: The geometry being checked if it's contained
    ///   - validatePolygon: If set to true, polygons that are invalid will return false
    /// - Returns: True if the geometry is within or on the edge of the polygon
    public func contains(geometry: any SMGeometry, validatePolygon: Bool = false) -> Bool {
        guard !validatePolygon || self.isValid else {
            return false
        }
        guard self.boundingBoxContainsBoundingBox(of: geometry) else {
            return false
        }
        guard !geometry.boundingBoxEnclosesBoundingBox(of: self) else {
            return false
        }
        // Check if all points are inside
        for vertex in geometry.vertices {
            if !self.contains(point: vertex, validatePolygon: false) {
                return false
            }
        }
        // Check for intersections that aren't touching
        for edge in geometry.edges {
            if self.intersects(geometry: edge) && !self.intersects(point: edge.origin) && !self.intersects(point: edge.end) {
                return false
            }
        }
        return true
    }
    
    /// Checks if the polygon encloses some geometry (the geometry exists inside and not on the edge nor outside polygon).
    /// - Parameters:
    ///   - geometry: The geometry being checked if it's enclosed
    ///   - validatePolygon: If set to true, polygons that are invalid will return false
    /// - Returns: True if the geometry is within the polygon
    public func encloses(geometry: any SMGeometry, validatePolygon: Bool = false) -> Bool {
        guard !validatePolygon || self.isValid else {
            return false
        }
        guard self.boundingBoxEnclosesBoundingBox(of: geometry) else {
            return false
        }
        guard !geometry.boundingBoxContainsBoundingBox(of: self) else {
            return false
        }
        // Check if all points are enclosed
        for vertex in geometry.vertices {
            if !self.encloses(point: vertex, validatePolygon: false) {
                return false
            }
        }
        // Check for intersections
        for edge in geometry.edges {
            if self.intersects(geometry: edge) {
                return false
            }
        }
        return true
    }
    
    /// The "point-in-polygon" algorithm by Randolph Franklin. Uses the ray-casting method.
    /// Does not explicitly address points on the edges of the polygon, which must be explicitly accounted for.
    /// - Returns: True if a point is contained inside this polygon.
    private func pnpoly(_ point: SMPoint) -> Bool {
        // https://www.eecs.umich.edu/courses/eecs380/HANDOUTS/PROJ2/InsidePoly.html
        let nvert = self.vertices.count
        var c = false
        for i in 0..<nvert {
            let j = (i == 0) ? nvert - 1 : i - 1
            if ((self.vertices[i].y.isGreater(than: point.y)) != (self.vertices[j].y.isGreater(than: point.y))) &&
                (point.x.isLess(than: (self.vertices[j].x - self.vertices[i].x) * (point.y - self.vertices[i].y) / (self.vertices[j].y - self.vertices[i].y) + self.vertices[i].x)) {
                c = !c
            }
        }
        return c
    }
    
    public mutating func orderClockwise() {
        guard self.isAnticlockwise else {
            return
        }
        self.vertices = self.vertices.reversed()
    }
    
    public mutating func orderAnticlockwise() {
        guard self.isClockwise else {
            return
        }
        self.vertices = self.vertices.reversed()
    }
    
    public func toString(decimalPlaces: Int = 2) -> String {
        return "[\(self.vertices.map({ $0.toString(decimalPlaces: decimalPlaces) }).joined(separator: ", "))]"
    }
    
    // MARK: - Operations
    
    public static func + (left: SMPolygon, right: SMPoint) -> SMPolygon {
        return SMPolygon(vertices: left.vertices.map({ $0 + right }))
    }

    public static func += (left: inout SMPolygon, right: SMPoint) {
        left = left + right
    }

    public static func - (left: SMPolygon, right: SMPoint) -> SMPolygon {
        return SMPolygon(vertices: left.vertices.map({ $0 - right }))
    }

    public static func -= (left: inout SMPolygon, right: SMPoint) {
        left = left - right
    }
    
    public static func == (lhs: SMPolygon, rhs: SMPolygon) -> Bool {
        guard lhs.vertices.count == rhs.vertices.count else {
            return false
        }
        for index in lhs.vertices.indices {
            if lhs.vertices[index] != rhs.vertices[index] {
                return false
            }
        }
        return true
    }
    
    // MARK: - Core Graphics
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        guard let first = self.vertices.first else {
            return path
        }
        path.move(to: first.cgPoint)
        path.addLines(between: self.vertices.map({ $0.cgPoint }))
        path.closeSubpath()
        return path
    }
    
    public var cgPathValidated: CGPath? {
        guard self.isValid else {
            return nil
        }
        return self.cgPath
    }
    
}
