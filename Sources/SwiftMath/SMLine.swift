//
//  SMLine.swift
//
//
//  Created by Andre Pham on 22/1/2024.
//

import Foundation

/// Represents an infinite line.
public struct SMLine: SMLinear, SMTransformable {

    // MARK: - Properties
    
    /// A point on the line
    public var origin: SMPoint
    /// A direction vector representing the line's direction (relative to origin, so still lies on the line)
    public var end: SMPoint

    // MARK: - Constructors

    public init(point: SMPoint, direction: SMPoint) {
        self.origin = point
        self.end = direction
    }
    
    public init(point: SMPoint, angle: SMAngle) {
        let arc = SMArc(center: point, radius: 1.0, startAngle: SMAngle(degrees: 0.0), endAngle: angle)
        self.init(point: point, direction: arc.endPoint)
    }
    
    public init(point: SMPoint, gradient: Double?) {
        var end = point
        if let gradient {
            end.translate(by: SMPoint(x: 1.0, y: gradient)) // rise / run
        } else {
            end.translate(by: SMPoint(x: 0.0, y: 1.0))
        }
        self.init(point: point, direction: end)
    }
    
    public func intersects(point: SMPoint) -> Bool {
        // Handle vertical lines
        if self.isVertical {
            return point.x.isEqual(to: self.origin.x)
        }
        // Calculate the slope and check if the point fits the line equation
        let slope = self.gradient ?? 0
        let yIntercept = self.origin.y - slope * self.origin.x
        return point.y.isEqual(to: slope * point.x + yIntercept)
    }
    
    public func intersection(with line: SMLinear) -> SMPoint? {
        // Handle parallel lines (no intersection)
        if self.isParallel(to: line) {
            return nil
        }
        // Handle vertical lines
        if self.isVertical {
            let y = line.gradient! * self.origin.x + (line.origin.y - line.gradient! * line.origin.x)
            return SMPoint(x: self.origin.x, y: y)
        } else if line.isVertical {
            let y = self.gradient! * line.origin.x + (self.origin.y - self.gradient! * self.origin.x)
            return SMPoint(x: line.origin.x, y: y)
        }
        // General case
        let m1 = self.gradient!
        let m2 = line.gradient!
        let b1 = self.origin.y - m1 * self.origin.x
        let b2 = line.origin.y - m2 * line.origin.x
        let x = (b2 - b1) / (m1 - m2)
        let y = m1 * x + b1
        return SMPoint(x: x, y: y)
    }

    // MARK: - Functions
    
    public func toString(decimalPlaces: Int = 2) -> String {
        return "Line through \(self.origin.toString(decimalPlaces: decimalPlaces)) -> \(self.end.toString(decimalPlaces: decimalPlaces))"
    }
    
    // MARK: - Transformations
    
    public mutating func translate(by point: SMPoint) {
        self.origin += point
        self.end += point
    }
    
    public mutating func translateCenter(to point: SMPoint) {
        self.translateToIntersect(point)
    }
    
    public mutating func translateToIntersect(_ point: SMPoint) {
        let newEnd = point + self.end - self.origin
        self.origin = point
        self.end = newEnd
    }
    
    public mutating func rotate(around center: SMPoint, by angle: SMAngle) {
        self.origin.rotate(around: center, by: angle)
        self.end.rotate(around: center, by: angle)
    }
    
    public mutating func scale(from point: SMPoint, scale: Double) {
        // Do nothing - SMLine is infinite in length
    }

    // MARK: - Operations
    
    public static func + (left: SMLine, right: SMPoint) -> SMLine {
        return SMLine(point: left.origin + right, direction: left.end + right)
    }

    public static func += (left: inout SMLine, right: SMPoint) {
        left = left + right
    }

    public static func - (left: SMLine, right: SMPoint) -> SMLine {
        return SMLine(point: left.origin - right, direction: left.end - right)
    }

    public static func -= (left: inout SMLine, right: SMPoint) {
        left = left - right
    }

    public static func == (lhs: SMLine, rhs: SMLine) -> Bool {
        return lhs.isParallel(to: rhs) && lhs.intersects(point: rhs.origin)
    }
    
}
