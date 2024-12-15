//
//  File.swift
//  
//
//  Created by Andre Pham on 22/1/2024.
//

import Foundation

/// Shared logic between finite lines (SMLineSegment) and infinite lines (SMLine)
public protocol SMLinear {
    
    var origin: SMPoint { get set }
    var end: SMPoint { get set }
    var gradient: Double? { get }
    var isVertical: Bool { get }
    var isHorizontal: Bool { get }
    var isValid: Bool { get }
    
    func intersects(point: SMPoint) -> Bool
    func intersection(with line: SMLinear) -> SMPoint?
    
}
extension SMLinear {
    
    /// The slope of the line segment
    public var gradient: Double? {
        guard !self.origin.x.isEqual(to: self.end.x) else {
            return nil
        }
        return (self.end.y - self.origin.y) / (self.end.x - self.origin.x)
    }
    /// The angle of the line, whereby the origin of the line is the center of the unit circle
    public var angle: SMAngle? {
        guard self.isValid else {
            return nil
        }
        return SMAngle(point1: self.origin + SMPoint(x: 1, y: 0), vertex: self.origin, point2: self.end)
    }
    /// If the line segment is vertical
    public var isVertical: Bool {
        return self.gradient == nil
    }
    /// If the line segment is horizontal
    public var isHorizontal: Bool {
        return self.origin.y.isEqual(to: self.end.y)
    }
    /// If the line segment is valid (can be drawn)
    public var isValid: Bool {
        return self.origin != self.end
    }
    /// The x-axis intercept
    public var xAxisIntercept: SMPoint? {
        return self.intersection(with: SMLine(point: SMPoint(), direction: SMPoint(x: 1.0, y: 0.0)))
    }
    /// The x-axis intercept
    public var yAxisIntercept: SMPoint? {
        return self.intersection(with: SMLine(point: SMPoint(), direction: SMPoint(x: 0.0, y: 1.0)))
    }
    
    /// Checks if two lines are parallel.
    /// If either line segments are invalid, they are not parallel.
    /// - Parameters:
    ///   - line: The line to compare
    /// - Returns: True if the two lines are parallel
    public func isParallel(to line: SMLinear, precision: Double = 1e-5) -> Bool {
        guard self.isValid && line.isValid else {
            return false
        }
        if let m1 = self.gradient, let m2 = line.gradient {
            return m1.isEqual(to: m2, precision: precision)
        }
        return self.gradient == line.gradient
    }
    
    /// Checks if two line segments intersect.
    /// Returns false if they don't intersect or are overlapping (infinite intersections).
    /// Intersection is still valid with invalid (zero length) line segments.
    /// - Parameters:
    ///   - line segment: The line segment to compare
    /// - Returns: True if the line segments intersect at a single point
    public func intersects(line: SMLinear) -> Bool {
        return self.intersection(with: line) != nil
    }
    
}
