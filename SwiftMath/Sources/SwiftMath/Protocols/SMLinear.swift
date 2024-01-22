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
        guard !SM.isEqual(self.origin.x, self.end.x) else {
            return nil
        }
        return (self.end.y - self.origin.y) / (self.end.x - self.origin.x)
    }
    /// If the line segment is vertical
    public var isVertical: Bool {
        return self.gradient == nil
    }
    /// If the line segment is horizontal
    public var isHorizontal: Bool {
        return SM.isEqual(self.origin.y, self.end.y)
    }
    /// If the line segment is valid (can be drawn)
    public var isValid: Bool {
        return self.origin != self.end
    }
    
    /// Checks if two lines are parallel.
    /// If either line segments are invalid, they are not parallel.
    /// - Parameters:
    ///   - line: The line to compare
    /// - Returns: True if the two lines are parallel
    public func isParallel(to line: SMLinear, precision: Double = doublePrecision) -> Bool {
        guard self.isValid && line.isValid else {
            return false
        }
        if let m1 = self.gradient, let m2 = line.gradient {
            return SM.isEqual(m1, m2, precision: precision)
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
