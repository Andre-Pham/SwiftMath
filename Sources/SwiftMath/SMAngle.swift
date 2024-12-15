//
//  SMAngle.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

open class SMAngle: SMClonable, Equatable {
    
    // MARK: - Properties
    
    public var radians: Double
    public var degrees: Double {
        return self.radians * 180.0 / .pi
    }
    /// The angle normalized such that it falls within the range [0, 2π)
    public var normalized: SMAngle {
        let result = self.clone()
        result.normalize()
        return result
    }
    /// The gradient (slope) equivalent (nil is undefined)
    public var gradient: Double? {
        if self.normalized.radians.isEqual(to: .pi / 2.0) {
            return nil
        }
        return tan(self.radians)
    }
    /// True if the normalised angle is less than 90 degrees
    public var isAcute: Bool {
        return self.normalized.radians.isLess(than: .pi / 2.0)
    }
    /// True if the normalised angle is exactly 90 degrees
    public var isRight: Bool {
        return self.normalized.radians.isEqual(to: .pi / 2.0)
    }
    /// True if the normalised angle is greater than 90 degrees
    public var isObtuse: Bool {
        return self.normalized.radians.isGreater(than: .pi / 2.0)
    }
    /// True if the normalised angle is 180 degrees
    public var isStraight: Bool {
        return self.normalized.radians.isEqual(to: Double.pi)
    }
    /// True if the angle is greater than 180 degrees
    public var isMinor: Bool {
        return self.normalized.radians.isLess(than: Double.pi)
    }
    /// True if the angle is less than 180 degrees
    public var isMajor: Bool {
        return self.normalized.radians.isGreater(than: Double.pi)
    }
    /// The angle which adds to this to make 90 degrees (nil if this is greater than 90 degrees)
    public var complement: SMAngle? {
        let normalized = self.normalized
        guard normalized.radians.isLessOrEqual(to: .pi / 2.0) else {
            return nil
        }
        return SMAngle(radians: .pi / 2.0) - normalized
    }
    /// The angle which adds to this to make 180 degrees (nil if this is greater than 180 degrees)
    public var supplementary: SMAngle? {
        let normalized = self.normalized
        guard normalized.radians.isLessOrEqual(to: Double.pi) else {
            return nil
        }
        return SMAngle(radians: Double.pi) - normalized
    }
    /// The angle which adds to this to make 360 degrees, given this is less than 180 degrees (nil if this is greater or equal to 180 degrees)
    public var reflex: SMAngle? {
        let normalized = self.normalized
        guard normalized.radians.isLess(than: Double.pi) else {
            return nil
        }
        return SMAngle(radians: 2.0 * .pi) - normalized
    }
    /// The angle which adds to this to make 360 degrees
    public var modularInverse: SMAngle {
        return SMAngle(radians: 2.0 * .pi) - self.normalized
    }
    /// This angle if it's less than 180 degrees, otherwise the modular inverse of this (the "inside" angle)
    public var minor: SMAngle {
        let normalized = self.normalized
        if self.radians.isLessOrEqual(to: Double.pi) {
            return normalized
        } else {
            return self.modularInverse
        }
    }
    /// This angle if it's greater than 180 degrees, otherwise the modular inverse of this (the "outside" angle)
    public var major: SMAngle {
        let normalized = self.normalized
        if self.radians.isGreaterOrEqual(to: Double.pi) {
            return normalized
        } else {
            return self.modularInverse
        }
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
    
    public init(degrees: Int) {
        self.radians = Double(degrees) * .pi / 180.0
    }
    
    public init(gradient: Double?) {
        if let gradient {
            self.radians = atan(gradient)
        } else {
            self.radians = .pi / 2.0
        }
    }
    
    public init() {
        self.radians = 0.0
    }
    
    /// Create an angle by calculating the counter-clockwise angle from `point1` to `point2` around `vertex`
    /// Example:
    /// ``` SMAngle(
    ///         point1: SMPoint(x: 1.0, y: 0.0),
    ///         vertex: SMPoint(),
    ///         point2: SMPoint(x: 0.0, y: 1.0)
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
        var angle = angle2 - angle1
        // Adjust the angle to be within the range [0, 2π]
        if angle.isLessThanZero() {
            angle += 2 * .pi
        }
        self.radians = angle
    }
    
    public required init(_ original: SMAngle) {
        self.radians = original.radians
    }
    
    // MARK: - Functions
    
    /// Normalize the current angle such that it falls within the range [0, 2π).
    /// Example:
    /// ``` var angle = SMAngle(radians: 3.0 * .pi)
    ///     angle.normalize()
    ///     angle.radians -> .pi
    /// ```
    public func normalize() {
        var result = self.radians.truncatingRemainder(dividingBy: (2.0 * .pi))
        if result.isLessThanZero() {
            result += (2.0 * .pi)
        }
        self.radians = result
    }
    
    /// Checks if this angle is equivalent to another (expressed on a unit circle).
    /// Example:
    /// ``` let angle1 = SMAngle(degrees: 90)
    ///     let angle2 = SMAngle(degrees: -270)
    ///     angle1.isEquivalent(to: angle2) -> True
    /// ```
    /// - Parameters:
    ///   - angle: The angle to compare against
    /// - Returns: True if the two angles are equivalent on the unit circle
    public func isEquivalent(to angle: SMAngle) -> Bool {
        return self.normalized == angle.normalized
    }
    
    public func toString(decimalPlaces: Int = 2) -> String {
        return "\(self.degrees.rounded(decimalPlaces: decimalPlaces)) deg"
    }
    
    // MARK: - Operations
    
    public static func + (lhs: SMAngle, rhs: SMAngle) -> SMAngle {
        return SMAngle(radians: lhs.radians + rhs.radians)
    }

    public static func += (lhs: inout SMAngle, rhs: SMAngle) {
        lhs = lhs + rhs
    }

    public static func - (lhs: SMAngle, rhs: SMAngle) -> SMAngle {
        return SMAngle(radians: lhs.radians - rhs.radians)
    }

    public static func -= (lhs: inout SMAngle, rhs: SMAngle) {
        lhs = lhs - rhs
    }

    public static func * (lhs: SMAngle, rhs: Double) -> SMAngle {
        return SMAngle(radians: lhs.radians * rhs)
    }

    public static func *= (lhs: inout SMAngle, rhs: Double) {
        lhs = lhs * rhs
    }

    public static func / (lhs: SMAngle, rhs: Double) -> SMAngle {
        return SMAngle(radians: lhs.radians / rhs)
    }

    public static func /= (lhs: inout SMAngle, rhs: Double) {
        lhs = lhs / rhs
    }
    
    public static func == (lhs: SMAngle, rhs: SMAngle) -> Bool {
        return lhs.radians.isEqual(to: rhs.radians)
    }
    
}
