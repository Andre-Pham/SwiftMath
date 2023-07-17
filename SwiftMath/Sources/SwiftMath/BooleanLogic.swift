//
//  BooleanLogic.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

public let doublePrecision: Double = 1e-5
public let floatPrecision: Float = 1e-5
public let cgFloatPrecision: CGFloat = 1e-5

public enum SM {
    
    // MARK: - Double

    /// `a < b`
    public static func isLess(_ a: Double, _ b: Double, precision: Double = doublePrecision) -> Bool {
        return (b - a > precision)
    }

    /// `a <= b`
    public static func isLessOrEqual(_ a: Double, _ b: Double, precision: Double = doublePrecision) -> Bool {
        return (isEqual(a, b, precision: precision) || isLess(a, b, precision: precision))
    }

    /// `a > b`
    public static func isGreater(_ a: Double, _ b: Double, precision: Double = doublePrecision) -> Bool {
        return (a - b > precision)
    }

    /// `a >= b`
    public static func isGreaterOrEqual(_ a: Double, _ b: Double, precision: Double = doublePrecision) -> Bool {
        return (isEqual(a, b, precision: precision) || isGreater(a, b, precision: precision))
    }

    /// `a == b`
    public static func isEqual(_ a: Double, _ b: Double, precision: Double = doublePrecision) -> Bool {
        return (abs(a - b) <= precision)
    }

    /// `x == 0`
    public static func isZero(_ x: Double, precision: Double = doublePrecision) -> Bool {
        return isEqual(x, 0.0, precision: precision)
    }

    /// `x < 0`
    public static func isLessZero(_ x: Double, precision: Double = doublePrecision) -> Bool {
        return isLess(x, 0.0, precision: precision)
    }

    /// `x <= 0`
    public static func isLessOrEqualZero(_ x: Double, precision: Double = doublePrecision) -> Bool {
        return isLessOrEqual(x, 0.0, precision: precision)
    }

    /// `x > 0`
    public static func isGreaterZero(_ x: Double, precision: Double = doublePrecision) -> Bool {
        return isGreater(x, 0.0, precision: precision)
    }

    /// `x >= 0`
    public static func isGreaterOrEqualZero(_ x: Double, precision: Double = doublePrecision) -> Bool {
        return isGreaterOrEqual(x, 0.0, precision: precision)
    }

    // MARK: - Float

    /// `a < b`
    public static func isLess(_ a: Float, _ b: Float, precision: Float = floatPrecision) -> Bool {
        return (b - a > precision)
    }

    /// `a <= b`
    public static func isLessOrEqual(_ a: Float, _ b: Float, precision: Float = floatPrecision) -> Bool {
        return (isEqual(a, b, precision: precision) || isLess(a, b, precision: precision))
    }

    /// `a > b`
    public static func isGreater(_ a: Float, _ b: Float, precision: Float = floatPrecision) -> Bool {
        return (a - b > precision)
    }

    /// `a >= b`
    public static func isGreaterOrEqual(_ a: Float, _ b: Float, precision: Float = floatPrecision) -> Bool {
        return (isEqual(a, b, precision: precision) || isGreater(a, b, precision: precision))
    }

    /// `a == b`
    public static func isEqual(_ a: Float, _ b: Float, precision: Float = floatPrecision) -> Bool {
        return (abs(a - b) <= precision)
    }

    /// `x == 0`
    public static func isZero(_ x: Float, precision: Float = floatPrecision) -> Bool {
        return isEqual(x, 0.0, precision: precision)
    }

    /// `x < 0`
    public static func isLessZero(_ x: Float, precision: Float = floatPrecision) -> Bool {
        return isLess(x, 0.0, precision: precision)
    }

    /// `x <= 0`
    public static func isLessOrEqualZero(_ x: Float, precision: Float = floatPrecision) -> Bool {
        return isLessOrEqual(x, 0.0, precision: precision)
    }

    /// `x > 0`
    public static func isGreaterZero(_ x: Float, precision: Float = floatPrecision) -> Bool {
        return isGreater(x, 0.0, precision: precision)
    }

    /// `x >= 0`
    public static func isGreaterOrEqualZero(_ x: Float, precision: Float = floatPrecision) -> Bool {
        return isGreaterOrEqual(x, 0.0, precision: precision)
    }

    // MARK: - CGFloat

    /// `a < b`
    public static func isLess(_ a: CGFloat, _ b: CGFloat, precision: CGFloat = cgFloatPrecision) -> Bool {
        return (b - a > precision)
    }

    /// `a <= b`
    public static func isLessOrEqual(_ a: CGFloat, _ b: CGFloat, precision: CGFloat = cgFloatPrecision) -> Bool {
        return (isEqual(a, b, precision: precision) || isLess(a, b, precision: precision))
    }

    /// `a > b`
    public static func isGreater(_ a: CGFloat, _ b: CGFloat, precision: CGFloat = cgFloatPrecision) -> Bool {
        return (a - b > precision)
    }

    /// `a >= b`
    public static func isGreaterOrEqual(_ a: CGFloat, _ b: CGFloat, precision: CGFloat = cgFloatPrecision) -> Bool {
        return (isEqual(a, b, precision: precision) || isGreater(a, b, precision: precision))
    }

    /// `a == b`
    public static func isEqual(_ a: CGFloat, _ b: CGFloat, precision: CGFloat = cgFloatPrecision) -> Bool {
        return (abs(a - b) <= precision)
    }

    /// `x == 0`
    public static func isZero(_ x: CGFloat, precision: CGFloat = cgFloatPrecision) -> Bool {
        return isEqual(x, 0.0, precision: precision)
    }

    /// `x < 0`
    public static func isLessZero(_ x: CGFloat, precision: CGFloat = cgFloatPrecision) -> Bool {
        return isLess(x, 0.0, precision: precision)
    }

    /// `x <= 0`
    public static func isLessOrEqualZero(_ x: CGFloat, precision: CGFloat = cgFloatPrecision) -> Bool {
        return isLessOrEqual(x, 0.0, precision: precision)
    }

    /// `x > 0`
    public static func isGreaterZero(_ x: CGFloat, precision: CGFloat = cgFloatPrecision) -> Bool {
        return isGreater(x, 0.0, precision: precision)
    }

    /// `x >= 0`
    public static func isGreaterOrEqualZero(_ x: CGFloat, precision: CGFloat = cgFloatPrecision) -> Bool {
        return isGreaterOrEqual(x, 0.0, precision: precision)
    }
    
}
