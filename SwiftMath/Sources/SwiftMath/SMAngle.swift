//
//  SMAngle.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

public struct SMAngle: SMClonable, Equatable {
    
    // MARK: - Properties
    
    public let radians: Double
    public var degrees: Double {
        return self.radians * 180.0 / .pi
    }
    
    // MARK: - Constructors
    
    public init(radians: Double) {
        self.radians = radians
    }
    
    public init(degrees: Double) {
        self.radians = degrees * .pi / 180.0
    }
    
    public init(radians: Float) {
        self.radians = Double(radians)
    }
    
    public init(degrees: Float) {
        self.radians = Double(degrees * .pi / 180.0)
    }
    
    /// Create an angle by calculating the counter-clockwise angle from `point1` to `point2` around `vertex`
    /// Example:
    /// ``` SMAngle(
    ///         point1: SMPoint(x: 0.0, y: 1.0),
    ///         vertex: SMPoint(),
    ///         point2: SMPoint(x: 1.0, y: 0.0)
    ///     ).degrees -> 90.0
    /// ```
    /// - Parameters:
    ///   - point1: The starting point of the angle
    ///   - vertex: The vertex of the angle
    ///   - point2: The ending point of the angle
    /// - Returns: A new `SMAngle` instance representing the counter-clockwise angle from `point1` to `point2`
    public init(point1: SMPoint, vertex: SMPoint, point2: SMPoint) {
        // Calculate the angles for the lines from vertex to point1 and from vertex to point2
        let angle1 = atan2(point1.y - vertex.y, point1.x - vertex.x)
        let angle2 = atan2(point2.y - vertex.y, point2.x - vertex.x)
        // Calculate the angle from point1 to point2 in counter-clockwise direction
        var angle = angle1 - angle2
        // Adjust the angle to be within the range [0, 2π]
        if SM.isLessZero(angle) {
            angle += 2 * .pi
        }
        self.radians = angle
    }
    
    public init(_ original: SMAngle) {
        self.radians = original.radians
    }
    
    // MARK: - Operations
    
    static func + (lhs: SMAngle, rhs: SMAngle) -> SMAngle {
        return SMAngle(radians: lhs.radians + rhs.radians)
    }

    static func += (lhs: inout SMAngle, rhs: SMAngle) {
        lhs = lhs + rhs
    }

    static func - (lhs: SMAngle, rhs: SMAngle) -> SMAngle {
        return SMAngle(radians: lhs.radians - rhs.radians)
    }

    static func -= (lhs: inout SMAngle, rhs: SMAngle) {
        lhs = lhs - rhs
    }

    static func * (lhs: SMAngle, rhs: Double) -> SMAngle {
        return SMAngle(radians: lhs.radians * rhs)
    }

    static func *= (lhs: inout SMAngle, rhs: Double) {
        lhs = lhs * rhs
    }

    static func / (lhs: SMAngle, rhs: Double) -> SMAngle {
        return SMAngle(radians: lhs.radians / rhs)
    }

    static func /= (lhs: inout SMAngle, rhs: Double) {
        lhs = lhs / rhs
    }
    
    public static func == (lhs: SMAngle, rhs: SMAngle) -> Bool {
        return SM.isEqual(lhs.radians, rhs.radians)
    }
    
}
