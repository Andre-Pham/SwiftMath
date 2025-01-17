//
//  SMPoint.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

/// Represents a 2D point.
public struct SMPoint: SMTransformable, Hashable {
    
    // MARK: - Properties
    
    public var x: Double
    public var y: Double
    
    // MARK: - Constructors
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    public init() {
        self.init(x: 0.0, y: 0.0)
    }
    
    public init(x: Float, y: Float) {
        self.init(x: Double(x), y: Double(y))
    }
    
    public init(x: Int, y: Int) {
        self.init(x: Double(x), y: Double(y))
    }
    
    // MARK: - Functions
    
    public func length(to point: SMPoint) -> Double {
        return SMLineSegment(origin: self, end: point).length
    }
    
    public func toString(decimalPlaces: Int = 2) -> String {
        return "(\(self.x.rounded(decimalPlaces: decimalPlaces)), \(self.y.rounded(decimalPlaces: decimalPlaces)))"
    }
    
    // MARK: - Transformations
    
    public mutating func translate(by point: SMPoint) {
        self.x += point.x
        self.y += point.y
    }
    
    public mutating func translateCenter(to point: SMPoint) {
        self.x = point.x
        self.y = point.y
    }
    
    /// Rotates this point counter-clockwise around a given `center` by a certain `angle`
    /// - Parameters:
    ///   - center: The center point to rotate around
    ///   - angle: The angle to rotate by
    public mutating func rotate(around center: SMPoint, by angle: SMAngle) {
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
    
    public mutating func scale(from point: SMPoint, scale: Double) {
        self.translate(by: point * -1)
        self.x *= scale
        self.y *= scale
        self.translate(by: point)
    }
    
    public mutating func translateX(_ amount: Double) {
        self.translate(by: SMPoint(x: amount, y: 0.0))
    }
    
    public mutating func translateY(_ amount: Double) {
        self.translate(by: SMPoint(x: 0.0, y: amount))
    }
    
    public mutating func translate(x: Double, y: Double) {
        self.translate(by: SMPoint(x: x, y: y))
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
        guard !scalar.isZero() else {
            fatalError("Division by zero is illegal")
        }
        return SMPoint(x: point.x / scalar, y: point.y / scalar)
    }

    public static func /= (point: inout SMPoint, scalar: Double) {
        point = point / scalar
    }

    public static func == (lhs: SMPoint, rhs: SMPoint) -> Bool {
        return lhs.x.isEqual(to: rhs.x) && lhs.y.isEqual(to: rhs.y)
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
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
