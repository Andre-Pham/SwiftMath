//
//  File.swift
//  
//
//  Created by Andre Pham on 18/12/2024.
//

import Foundation

public protocol SMTransformable: Equatable {
    
    /// Translate the geometry vertically and horizontally.
    /// - Parameters:
    ///   - point: A point, by which its x translates horizontally and its y translates vertically
    mutating func translate(by point: SMPoint)
    /// Translate the geometry's center to a point.
    /// - Parameters:
    ///   - point: The point the center of the geometry will be translated to
    mutating func translateCenter(to point: SMPoint)
    /// Rotate the geometry counter-clockwise around a given center by a given angle.
    /// - Parameters:
    ///   - center: The center to rotate around
    ///   - angle: The angle to rotate by (counter-clockwise)
    mutating func rotate(around center: SMPoint, by angle: SMAngle)
    /// Scale this geometry from a given point by a given scale (factor).
    /// - Parameters:
    ///   - point: The point to scale from
    ///   - scale: The factor to scale by
    mutating func scale(from point: SMPoint, scale: Double)
    /// Translate the geometry by a point's coordinates.
    /// - Parameters:
    ///   - left: The geometry to translate
    ///   - right: A point, by which its x translates horizontally and its y translates vertically
    /// - Returns: A copy of the original geometry, translated
    static func + (left: Self, right: SMPoint) -> Self
    /// Translate the geometry by a point's coordinates (in-place).
    /// - Parameters:
    ///   - left: The geometry to translate (modified in-place)
    ///   - right: A point, by which its x translates horizontally and its y translates vertically
    static func += (left: inout Self, right: SMPoint)
    /// Translate the geometry by the negative of a point's coordinates.
    /// - Parameters:
    ///   - left: The geometry to translate
    ///   - right: A point, by which its x is subtracted horizontally and its y is subtracted vertically
    /// - Returns: A copy of the original geometry, translated
    static func - (left: Self, right: SMPoint) -> Self
    /// Translate the geometry by the negative of a point's coordinates (in-place)..
    /// - Parameters:
    ///   - left: The geometry to translate (modified in-place)
    ///   - right: A point, by which its x is subtracted horizontally and its y is subtracted vertically
    static func -= (left: inout Self, right: SMPoint)
    /// Check if this and another geometry is geometrically equivalent (same vertices in the same place).
    /// - Parameters:
    ///   - lhs: First geometry to compare (check if geometrically equivalent)
    ///   - rhs: Second geometry to compare (check if geometrically equivalent)
    /// - Returns: True if the two geometries are geometrically equivalent (same vertices in the same place)
    static func == (lhs: Self, rhs: Self) -> Bool
    
}
extension SMTransformable {
    
    public mutating func translate(x: Double, y: Double) {
        self.translate(by: SMPoint(x: x, y: y))
    }
    
    public mutating func translateX(_ amount: Double) {
        self.translate(by: SMPoint(x: amount, y: 0.0))
    }
    
    public mutating func translateY(_ amount: Double) {
        self.translate(by: SMPoint(x: 0.0, y: amount))
    }
    
    public func translated(x: Double, y: Double) -> Self {
        return self + SMPoint(x: x, y: y)
    }
    
    public func translated(by point: SMPoint) -> Self {
        return self + point
    }
    
    public func translatedX(by amount: Double) -> Self {
        return self + SMPoint(x: amount, y: 0.0)
    }
    
    public func translatedY(by amount: Double) -> Self {
        return self + SMPoint(x: 0.0, y: amount)
    }
    
}
