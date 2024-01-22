//
//  SMLine.swift
//
//
//  Created by Andre Pham on 22/1/2024.
//

import Foundation

public class SMLine: SMLinear, SMClonable, Equatable {

    // MARK: - Properties
    
    /// A point on the line
    public var origin: SMPoint
    /// A direction vector representing the line's direction
    public var end: SMPoint

    // MARK: - Constructors

    public init(point: SMPoint, direction: SMPoint) {
        self.origin = point
        self.end = direction
    }
    
    public convenience init(origin: SMPoint, angle: SMAngle, length: Double) {
        let arc = SMArc(center: origin, radius: length, startAngle: SMAngle(degrees: 0.0), endAngle: angle)
        self.init(point: origin, direction: arc.endPoint)
    }
    
    public required init(_ original: SMLine) {
        self.origin = original.origin
        self.end = original.end
    }
    
    public func intersects(point: SMPoint) -> Bool {
        // Handle vertical lines
        if self.isVertical {
            return SM.isEqual(point.x, self.origin.x)
        }
        // Calculate the slope and check if the point fits the line equation
        let slope = self.gradient ?? 0
        let yIntercept = self.origin.y - slope * self.origin.x
        return SM.isEqual(point.y, slope * point.x + yIntercept)
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
    
    public func toString() -> String {
        return "SMLine: Point \(self.origin.toString()), Direction \(self.end.toString())"
    }

    // MARK: - Operations

    public static func == (lhs: SMLine, rhs: SMLine) -> Bool {
        return lhs.isParallel(to: rhs) && lhs.intersects(point: rhs.origin)
    }
    
}
