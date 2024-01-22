//
//  SMPoint.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

public class SMPoint: SMClonable, Equatable {
    
    // MARK: - Properties
    
    public var x: Double
    public var y: Double
    
    // MARK: - Constructors
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    public convenience init() {
        self.init(x: 0.0, y: 0.0)
    }
    
    public convenience init(x: Float, y: Float) {
        self.init(x: Double(x), y: Double(y))
    }
    
    public convenience init(x: Int, y: Int) {
        self.init(x: Double(x), y: Double(y))
    }
    
    public required init(_ original: SMPoint) {
        self.x = original.x
        self.y = original.y
    }
    
    // MARK: - Functions
    
    /// Rotates this point counter-clockwise around a given `center` by a certain `angle`
    /// - Parameters:
    ///   - center: The center point to rotate around
    ///   - angle: The angle to rotate by
    public func rotate(around center: SMPoint, by angle: SMAngle) {
        // Translate point back to origin
        let xTranslated = self.x - center.x
        let yTranslated = self.y - center.y
        // Rotate the point around the origin
        let xRotated = xTranslated * cos(angle.radians) - yTranslated * sin(angle.radians)
        let yRotated = xTranslated * sin(angle.radians) + yTranslated * cos(angle.radians)
        // Translate back
        self.x = xRotated + center.x
        self.y = yRotated + center.y
    }
    
    /// Creates a new point from this point rotated counter-clockwise around a given `center` by a certain `angle`
    /// - Parameters:
    ///   - center: The center point to rotate around
    ///   - angle: The angle to rotate by
    /// - Returns: A new point rotated counter-clockwise
    public func rotated(around center: SMPoint, by angle: SMAngle) -> SMPoint {
        let result = self.clone()
        result.rotate(around: center, by: angle)
        return result
    }
    
    public func length(to point: SMPoint) -> Double {
        return SMLineSegment(origin: self, end: point).length
    }
    
    public func toString(decimalPlaces: Int = 2) -> String {
        return "SMPoint: (\(self.x.rounded(decimalPlaces: decimalPlaces)), \(self.y.rounded(decimalPlaces: decimalPlaces)))"
    }
    
    // MARK: - Operations

    public static func + (left: SMPoint, right: SMPoint) -> SMPoint {
        return SMPoint(x: left.x + right.x, y: left.y + right.y)
    }

    public static func += (left: inout SMPoint, right: SMPoint) {
        left = left + right
    }

    public static func - (left: SMPoint, right: SMPoint) -> SMPoint {
        return SMPoint(x: left.x - right.x, y: left.y - right.y)
    }

    public static func -= (left: inout SMPoint, right: SMPoint) {
        left = left - right
    }

    public static func * (point: SMPoint, scalar: Double) -> SMPoint {
        return SMPoint(x: point.x * scalar, y: point.y * scalar)
    }

    public static func *= (point: inout SMPoint, scalar: Double) {
        point = point * scalar
    }

    public static func / (point: SMPoint, scalar: Double) -> SMPoint {
        guard !SM.isZero(scalar) else {
            print("Error: Division by zero.")
            return point
        }
        return SMPoint(x: point.x / scalar, y: point.y / scalar)
    }

    public static func /= (point: inout SMPoint, scalar: Double) {
        point = point / scalar
    }

    public static func == (lhs: SMPoint, rhs: SMPoint) -> Bool {
        return SM.isEqual(lhs.x, rhs.x) && SM.isEqual(lhs.y, rhs.y)
    }
    
    // MARK: - Core Graphics
    
    public var cgPoint: CGPoint {
        return CGPoint(x: self.x, y: self.y)
    }
    
    public init(_ cgPoint: CGPoint) {
        self.x = cgPoint.x
        self.y = cgPoint.y
    }
    
}
