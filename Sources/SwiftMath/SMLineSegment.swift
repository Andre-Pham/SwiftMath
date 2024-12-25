//
//  SMLineSegment.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation
import CoreGraphics

/// Represents a line segment.
/// A straight line between two points.
public struct SMLineSegment: SMLinear, SMGeometry {
    
    // MARK: - Properties
    
    /// The origin the line segment
    public var origin: SMPoint
    /// The end of the line segment
    public var end: SMPoint
    /// This geometry's vertices (ordered)
    public var vertices: [SMPoint] {
        return [self.origin, self.end]
    }
    /// This geometry's edges (ordered)
    public var edges: [SMLineSegment] {
        return [self]
    }
    /// The line segment midpoint
    public var midPoint: SMPoint {
        let midX = (self.origin.x + self.end.x)/2.0
        let midY = (self.origin.y + self.end.y)/2.0
        return SMPoint(x: midX, y: midY)
    }
    /// The line segment length
    public var length: Double {
        let dx = self.end.x - self.origin.x
        let dy = self.end.y - self.origin.y
        return sqrt(dx * dx + dy * dy)
    }
    /// This line segment, flipped
    public var flipped: SMLineSegment {
        return SMLineSegment(origin: self.end, end: self.origin)
    }
    /// This line, infinite instead of a segment
    public var asInfiniteLine: SMLine {
        return SMLine(point: self.origin, direction: self.end)
    }
    /// The bounding box of the line segment
    public var boundingBox: SMRect {
        return SMRect(
            minX: min(self.origin.x, self.end.x),
            maxX: max(self.origin.x, self.end.x),
            minY: min(self.origin.y, self.end.y),
            maxY: max(self.origin.y, self.end.y)
        )
    }
    
    // MARK: - Constructors
    
    public init(origin: SMPoint, end: SMPoint) {
        self.origin = origin
        self.end = end
    }
    
    public init(origin: SMPoint, angle: SMAngle, length: Double) {
        let arc = SMArc(center: origin, radius: length, startAngle: SMAngle(degrees: 0.0), endAngle: angle)
        self.init(origin: origin, end: arc.endPoint)
    }
    
    public init(origin: SMPoint, gradient: Double?, length: Double) {
        self.init(origin: origin, angle: SMAngle(gradient: gradient), length: length)
    }
    
    // MARK: - Functions
    
    /// Swap the origin and end points.
    public mutating func flip() {
        let newOrigin = self.end
        self.end = self.origin
        self.origin = newOrigin
    }
    
    /// Extend or contract the line's length by a certain amount. By default, adjusts the line's end.
    /// If the length is negative and has a magnitude greater than the line's original length, the adjusted point continues moving in the collinear direction it was travelling from being contracted.
    /// - Parameters:
    ///   - length: The length to extend (+) or contract (-) by
    ///   - anchorEnd: True if the end should be used as the anchor (default is false)
    public mutating func adjustLength(by length: Double, anchorEnd: Bool = false) {
        guard self.isValid else {
            // An invalid line with zero length cannot have its length adjusted
            // (what direction would it go?)
            return
        }
        let translation = anchorEnd ? self.end : self.origin
        self.translate(by: translation * -1)
        let proportion = (length + self.length)/self.length
        if anchorEnd {
            self.origin *= proportion
        } else {
            self.end *= proportion
        }
        self.translate(by: translation)
    }
    
    /// Set the line's length. By default, adjusts the line's end.
    /// Setting a negative length is valid - the adjusted point extends in the opposite direction.
    /// - Parameters:
    ///   - length: The new length (negative to go in the opposite direction from the anchored point)
    ///   - anchorEnd: True if the end should be used as the anchor (default is false)
    public mutating func setLength(to length: Double, anchorEnd: Bool = false) {
        guard self.isValid else {
            // An invalid line with zero length cannot have its length adjusted
            // (what direction would it go?)
            return
        }
        guard !length.isZero() else {
            if anchorEnd {
                self.origin = self.end
            } else {
                self.end = self.origin
            }
            return
        }
        let translation = anchorEnd ? self.end : self.origin
        self.translate(by: translation * -1)
        let proportion = length/self.length
        if anchorEnd {
            self.origin *= proportion
        } else {
            self.end *= proportion
        }
        self.translate(by: translation)
    }
    
    /// Gets the point at a given proportional length of the line segment. Measures from the origin point towards the end point.
    /// A proportion of 0.5 would return the mid point.
    /// A proportion of 1.0 would return the end point.
    /// - Parameters:
    ///   - proportion: The proportion of the line segment's length from the origin point at which the returned point lies
    /// - Returns: The point at the proportional distance (relative to the line segment's length) from the origin point
    public func pointAtProportion(_ proportion: Double) -> SMPoint {
        guard self.isValid else {
            return self.origin
        }
        let x = self.origin.x + proportion*(self.end.x - self.origin.x)
        let y = self.origin.y + proportion*(self.end.y - self.origin.y)
        return SMPoint(x: x, y: y)
    }
    
    /// Checks if two line segments intercept infinitely (overlap).
    /// If either line segments are invalid (zero length), there isn't infinite intercepts, hence no overlap.
    /// - Parameters:
    ///   - line segment: The line segment to compare
    /// - Returns: True if there are infinite intercept points
    public func overlaps(with line: SMLineSegment) -> Bool {
        // They must be parallel to overlap
        guard self.isParallel(to: line) else {
            return false
        }
        // If they intercept, there's only a single intercept point - they don't overlap
        if self.intersects(line: line) {
            return false
        }
        // If they overlap, it's guaranteed at least one end point is in the other line segment
        return (
            self.intersects(point: line.origin) 
            || self.intersects(point: line.end)
            || line.intersects(point: self.origin)
            || line.intersects(point: self.end)
        )
    }
    
    /// Checks if a point lies on the line segment (inclusive).
    /// Intersection is still valid if the line segment is invalid (zero length).
    /// - Parameters:
    ///   - point: The point to check intersection
    /// - Returns: True if the point lies on the line segment (inclusive)
    public func intersects(point: SMPoint) -> Bool {
        if let gradient = self.gradient {
            // Non-vertical line segments
            let expectedY = gradient*(point.x - self.origin.x) + self.origin.y
            let existsOnInfiniteLine = expectedY.isEqual(to: point.y)
            let existsInBoundingBox = self.boundingBoxContains(point: point)
            return existsInBoundingBox && existsOnInfiniteLine
        } else {
            // Vertical line segments
            guard let maxY, let minY else {
                return false
            }
            return (
                self.origin.x.isEqual(to: point.x)
                && point.y.isLessOrEqual(to: maxY)
                && point.y.isGreaterOrEqual(to: minY)
            )
        }
    }
    
    /// Calculates the intersection point of two line segments if they intersect, or nil if they don't intersect or are overlapping (infinite intersections).
    /// Intersection is still valid with invalid (zero length) line segments.
    /// - Parameters:
    ///   - line segment: The line segment to compare
    /// - Returns: The point at which the two line segments intersect, or nil if they don't intersect or are overlapping (infinite intersections)
    public func intersection(with line: SMLinear) -> SMPoint? {
        // If these are both point lines
        if !self.isValid && !line.isValid {
            if self.origin == line.origin {
                return self.origin
            } else {
                return nil
            }
        }
        // If just this is a point line
        if !self.isValid {
            if line.intersects(point: self.origin) {
                return self.origin
            } else {
                return nil
            }
        }
        // If just the other line is a point line
        if !line.isValid {
            if self.intersects(point: line.origin) {
                return line.origin
            } else {
                return nil
            }
        }
        // If both are valid lines
        if self.gradient == nil {
            if line.gradient == nil {
                // Both lines are vertical and parallel
                return nil
            } else {
                // Only self is vertical
                let x = self.origin.x
                let lineYIntercept = line.origin.y - (line.gradient!*line.origin.x)
                let y = line.gradient!*x + lineYIntercept
                let point = SMPoint(x: x, y: y)
                return (self.intersects(point: point) && line.intersects(point: point)) ? point : nil
            }
        } else if line.gradient == nil {
            // Only other line is vertical, calculate intersection
            let x = line.origin.x
            let yIntercept = self.origin.y - (self.gradient!*self.origin.x)
            let y = self.gradient!*x + yIntercept
            let point = SMPoint(x: x, y: y)
            return (self.intersects(point: point) && line.intersects(point: point)) ? point : nil
        }
        // Calculate y-intercepts
        let b1 = self.origin.y - (self.gradient!*self.origin.x)
        let b2 = line.origin.y - (line.gradient!*line.origin.x)
        // Check if the lines are parallel
        if self.gradient == line.gradient {
            if let line = line as? Self,
               let touchingPoint = self.touchingPoint(with: line) {
                return touchingPoint
            } else {
                return nil
            }
        }
        let x = (b2 - b1) / (self.gradient! - line.gradient!)
        let y = self.gradient!*x + b1
        let point = SMPoint(x: x, y: y)
        return (self.intersects(point: point) && line.intersects(point: point)) ? point : nil
    }
    
    /// Checks if two line segments intersect at their end points (without overlapping).
    /// If the line segments intersect at their end points and either or both are invalid line segments (zero length), it still counts as they are intersecting at their end points without overlapping.
    /// - Parameters:
    ///   - line segment: The line segment to compare
    /// - Returns: The point at which they touch, or nil if they don't
    public func touchingPoint(with line: SMLineSegment) -> SMPoint? {
        var touchingOrigin = false
        var touchingEnd = false
        if self.origin == line.origin || self.origin == line.end {
            touchingOrigin = true
        }
        if self.end == line.origin || self.end == line.end {
            touchingEnd = true
        }
        if touchingOrigin && touchingEnd {
            if !self.isValid {
                return self.origin
            } else if !line.isValid {
                return line.origin
            } else {
                // They're overlapping
                return nil
            }
        } else if touchingOrigin {
            if self.gradient == line.gradient {
                if self.origin == line.end {
                    if line.boundingBoxContains(point: self.end) || self.boundingBoxContains(point: line.origin) {
                        return nil
                    }
                } else if self.origin == line.origin {
                    if line.boundingBoxContains(point: self.end) || self.boundingBoxContains(point: line.end) {
                        return nil
                    }
                }
            }
            return self.origin
        } else if touchingEnd {
            if self.gradient == line.gradient {
                if self.end == line.origin {
                    if line.boundingBoxContains(point: self.origin) || self.boundingBoxContains(point: line.end) {
                        return nil
                    }
                } else if self.end == line.end {
                    if line.boundingBoxContains(point: self.origin) || self.boundingBoxContains(point: line.origin) {
                        return nil
                    }
                }
            }
            return self.end
        }
        return nil
    }
    
    public func touches(line: SMLineSegment) -> Bool {
        return self.touchingPoint(with: line) != nil
    }
    
    public func matchesGeometry(of line: SMLineSegment) -> Bool {
        return self == line || self.flipped == line
    }
    
    public func isCollinear(with line: SMLineSegment) -> Bool {
        if !self.isValid && !line.isValid {
            return self.origin == line.origin
        } else if !self.isValid {
            return line.intersects(point: self.origin)
        } else if !line.isValid {
            return self.intersects(point: line.origin)
        }
        return self.asInfiniteLine == line.asInfiniteLine
    }
    
    public func isCollinear(with line: SMLine) -> Bool {
        guard self.isValid else {
            return line.intersects(point: self.origin)
        }
        return self.isParallel(to: line) && line.intersects(point: self.origin)
    }
    
    public func toString(decimalPlaces: Int = 2) -> String {
        return "\(self.origin.toString(decimalPlaces: decimalPlaces)) -> \(self.end.toString(decimalPlaces: decimalPlaces))"
    }
    
    // MARK: - Transformations
    
    public mutating func translate(by point: SMPoint) {
        self.origin += point
        self.end += point
    }
    
    public mutating func translateCenter(to point: SMPoint) {
        self.translate(by: point - self.midPoint)
    }
    
    public mutating func rotate(around center: SMPoint, by angle: SMAngle) {
        self.origin.rotate(around: center, by: angle)
        self.end.rotate(around: center, by: angle)
    }
    
    public mutating func scale(from point: SMPoint, scale: Double) {
        self.translate(by: point * -1)
        self.origin *= scale
        self.end *= scale
        self.translate(by: point)
    }
    
    // MARK: - Operations
    
    public static func + (left: SMLineSegment, right: SMPoint) -> SMLineSegment {
        return SMLineSegment(origin: left.origin + right, end: left.end + right)
    }

    public static func += (left: inout SMLineSegment, right: SMPoint) {
        left = left + right
    }

    public static func - (left: SMLineSegment, right: SMPoint) -> SMLineSegment {
        return SMLineSegment(origin: left.origin - right, end: left.end - right)
    }

    public static func -= (left: inout SMLineSegment, right: SMPoint) {
        left = left - right
    }
    
    public static func == (lhs: SMLineSegment, rhs: SMLineSegment) -> Bool {
        return lhs.origin == rhs.origin && lhs.end == rhs.end
    }
    
    // MARK: - Core Graphics
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        path.move(to: self.origin.cgPoint)
        path.addLine(to: self.end.cgPoint)
        return path
    }
    
    public var cgPathValidated: CGPath? {
        guard self.isValid else {
            return nil
        }
        return self.cgPath
    }
    
}
