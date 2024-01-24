//
//  SMPolygon.swift
//
//
//  Created by Andre Pham on 19/1/2024.
//

import Foundation

public class SMPolygon: SMClonable {
    
    public private(set) var orderedPoints = [SMPoint]()
    public var lineSegments: [SMLineSegment] {
        guard self.orderedPoints.count > 1 else {
            return []
        }
        var result = [SMLineSegment]()
        for index in self.orderedPoints.indices.dropLast() {
            result.append(SMLineSegment(origin: self.orderedPoints[index], end: self.orderedPoints[index + 1]))
        }
        result.append(SMLineSegment(origin: self.orderedPoints.last!, end: self.orderedPoints.first!))
        return result
    }
    public var isValid: Bool {
        // Must at least be a triangle
        guard self.orderedPoints.count > 2 else {
            return false
        }
        let lineSegments = self.lineSegments
        if !lineSegments.allSatisfy({ $0.isValid }) {
            // One or more line segments are invalid
            return false
        }
        for index1 in lineSegments.indices {
            for index2 in lineSegments.indices {
                guard index1 != index2 else {
                    continue
                }
                let linesAreAdjacent = abs(index1 - index2) == 1 || abs(index1 - index2) == (lineSegments.count - 1)
                let line1 = lineSegments[index1]
                let line2 = lineSegments[index2]
                if !linesAreAdjacent && line1.intersects(line: line2) {
                    // Lines are not adjacent yet they intersect
                    return false
                }
                if line1.overlaps(with: line2) {
                    // Lines overlap
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
        for i in self.orderedPoints.indices {
            let current = self.orderedPoints[i]
            let next = self.orderedPoints[(i + 1)%self.orderedPoints.count]
            sum += (current.x * next.y) - (next.x * current.y)
        }
        // Closing the loop: adding the product of the last and the first point
        let last = self.orderedPoints.last!
        let first = self.orderedPoints.first!
        sum += (last.x * first.y) - (first.x * last.y)
        return 0.5 * abs(sum)
    }
    public var perimeter: Double? {
        guard self.isValid else {
            return nil
        }
        var totalLength = self.orderedPoints.last!.length(to: self.orderedPoints.first!)
        for index in self.orderedPoints.indices.dropLast() {
            totalLength += self.orderedPoints[index].length(to: self.orderedPoints[index + 1])
        }
        return totalLength
    }
    public var pointCollection: SMPointCollection {
        return SMPointCollection(points: self.orderedPoints)
    }
    public var isClockwise: Bool {
        // https://stackoverflow.com/a/1165943
        return SM.isGreaterZero(self.lineSegments.reduce(0.0, { $0 + ($1.end.x - $1.origin.x) * ($1.end.y + $1.origin.y) }))
    }
    public var isAnticlockwise: Bool {
        // https://stackoverflow.com/a/1165943
        return SM.isLessZero(self.lineSegments.reduce(0.0, { $0 + ($1.end.x - $1.origin.x) * ($1.end.y + $1.origin.y) }))
    }
    
    // MARK: - Constructors
    
    public init(orderedPoints: [SMPoint]) {
        self.orderedPoints = orderedPoints
    }
    
    public convenience init(orderedPoints: SMPoint...) {
        self.init(orderedPoints: orderedPoints)
    }
    
    public required init(_ original: SMPolygon) {
        self.orderedPoints = original.orderedPoints.clone()
    }
    
    // MARK: - Functions
    
    public func add(_ point: SMPoint) {
        self.orderedPoints.append(point.clone())
    }
    
    public func remove(at index: Int) -> SMPoint? {
        guard index < self.orderedPoints.endIndex else {
            return nil
        }
        return self.orderedPoints.remove(at: index)
    }
    
    public func contains(point: SMPoint, checkEdges: Bool = true, validatePolygon: Bool = false) -> Bool {
        guard validatePolygon || self.isValid else {
            return false
        }
        guard self.pointCollection.boundingBox.contains(point: point) else {
            return false
        }
        if checkEdges {
            for edge in self.lineSegments {
                if edge.intersects(point: point) {
                    return true
                }
            }
        }
        // https://www.eecs.umich.edu/courses/eecs380/HANDOUTS/PROJ2/InsidePoly.html
        let nvert = self.orderedPoints.count
        var c = false
        for i in 0..<nvert {
            let j = (i == 0) ? nvert - 1 : i - 1
            if ((self.orderedPoints[i].y > point.y) != (self.orderedPoints[j].y > point.y)) &&
                (point.x < (self.orderedPoints[j].x - self.orderedPoints[i].x) * (point.y - self.orderedPoints[i].y) / (self.orderedPoints[j].y - self.orderedPoints[i].y) + self.orderedPoints[i].x) {
                c = !c
            }
        }
        return c
    }
    
    public func encloses(point: SMPoint, validatePolygon: Bool = false) -> Bool {
        guard validatePolygon || self.isValid else {
            return false
        }
        guard self.pointCollection.boundingBox.encloses(point: point) else {
            return false
        }
        for edge in self.lineSegments {
            if edge.intersects(point: point) {
                return false
            }
        }
        return self.contains(point: point, checkEdges: false, validatePolygon: false)
    }
    
    public func contains(polygon: SMPolygon, checkEdges: Bool = true, validatePolygon: Bool = false) -> Bool {
        guard validatePolygon || self.isValid else {
            return false
        }
        guard self.pointCollection.boundingBox.contains(rect: polygon.pointCollection.boundingBox) else {
            return false
        }
        guard !polygon.pointCollection.boundingBox.encloses(rect: self.pointCollection.boundingBox) else {
            return false
        }
        for vertex in polygon.orderedPoints {
            if !self.contains(point: vertex, checkEdges: checkEdges, validatePolygon: false) {
                return false
            }
        }
        return true
    }
    
    public func encloses(polygon: SMPolygon, validatePolygon: Bool = false) -> Bool {
        guard validatePolygon || self.isValid else {
            return false
        }
        guard self.pointCollection.boundingBox.encloses(rect: polygon.pointCollection.boundingBox) else {
            return false
        }
        guard !polygon.pointCollection.boundingBox.contains(rect: self.pointCollection.boundingBox) else {
            return false
        }
        for vertex in polygon.orderedPoints {
            if !self.encloses(point: vertex) {
                return false
            }
        }
        return true
    }
    
    public func intersects(point: SMPoint) -> Bool {
        for segment in self.lineSegments {
            if segment.intersects(point: point) {
                return true
            }
        }
        return false
    }
    
    public func overlaps(polygon: SMPolygon) -> Bool {
        guard self.pointCollection.boundingBox.intersects(with: polygon.pointCollection.boundingBox) else {
            return false
        }
        for lineSegment in self.lineSegments {
            for otherLineSegment in polygon.lineSegments {
                if lineSegment.intersects(line: otherLineSegment) {
                    return true
                }
            }
        }
        return false
    }
    
    public func orderClockwise() {
        guard self.isAnticlockwise else {
            return
        }
        self.orderedPoints = self.orderedPoints.reversed()
    }
    
    public func orderAnticlockwise() {
        guard self.isClockwise else {
            return
        }
        self.orderedPoints = self.orderedPoints.reversed()
    }
    
    // MARK: - Transformations
    
    public func translate(by point: SMPoint) {
        for index in self.orderedPoints.indices {
            self.orderedPoints[index] += point
        }
    }
    
    public func rotate(around center: SMPoint, by angle: SMAngle) {
        for index in self.orderedPoints.indices {
            self.orderedPoints[index].rotate(around: center, by: angle)
        }
    }
    
}
