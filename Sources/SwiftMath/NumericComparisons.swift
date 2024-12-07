//
//  NumericComparisons.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

extension Double {
    
    internal static let defaultPrecision: Double = 1e-5
    
    /// `self < x`
    internal func isLess(than x: Double, precision: Double = Self.defaultPrecision) -> Bool {
        return (x - self > precision)
    }
    
    /// `self < x`
    internal func isLess(than x: Float, precision: Double = Self.defaultPrecision) -> Bool {
        return self.isLess(than: Double(x), precision: precision)
    }
    
    /// `self < x`
    internal func isLess(than x: CGFloat, precision: Double = Self.defaultPrecision) -> Bool {
        return self.isLess(than: Double(x), precision: precision)
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: Double, precision: Double = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: x, precision: precision) || self.isLess(than: x, precision: precision)
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: Float, precision: Double = Self.defaultPrecision) -> Bool {
        return self.isLessOrEqual(to: Double(x), precision: precision)
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: CGFloat, precision: Double = Self.defaultPrecision) -> Bool {
        return self.isLessOrEqual(to: Double(x), precision: precision)
    }
    
    /// `self > x`
    internal func isGreater(than x: Double, precision: Double = Self.defaultPrecision) -> Bool {
        return (self - x > precision)
    }
    
    /// `self > x`
    internal func isGreater(than x: Float, precision: Double = Self.defaultPrecision) -> Bool {
        return self.isGreater(than: Double(x), precision: precision)
    }
    
    /// `self > x`
    internal func isGreater(than x: CGFloat, precision: Double = Self.defaultPrecision) -> Bool {
        return self.isGreater(than: Double(x), precision: precision)
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: Double, precision: Double = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: x, precision: precision) || self.isGreater(than: x, precision: precision)
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: Float, precision: Double = Self.defaultPrecision) -> Bool {
        return self.isGreaterOrEqual(to: Double(x), precision: precision)
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: CGFloat, precision: Double = Self.defaultPrecision) -> Bool {
        return self.isGreaterOrEqual(to: Double(x), precision: precision)
    }
    
    /// `self == x`
    internal func isEqual(to x: Double, precision: Double = Self.defaultPrecision) -> Bool {
        return (abs(self - x) <= precision)
    }
    
    /// `self == x`
    internal func isEqual(to x: Float, precision: Double = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: Double(x), precision: precision)
    }
    
    /// `self == x`
    internal func isEqual(to x: CGFloat, precision: Double = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: Double(x), precision: precision)
    }
    
    /// `self == 0`
    internal func isZero(precision: Double = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: 0.0, precision: precision)
    }
    
    /// `self < 0`
    internal func isLessThanZero(precision: Double = Self.defaultPrecision) -> Bool {
        return self.isLess(than: 0.0, precision: precision)
    }
    
    /// `self <= 0`
    internal func isLessOrEqualZero(precision: Double = Self.defaultPrecision) -> Bool {
        return self.isLessOrEqual(to: 0.0, precision: precision)
    }
    
    /// `self > 0`
    internal func isGreaterThanZero(precision: Double = Self.defaultPrecision) -> Bool {
        return self.isGreater(than: 0.0, precision: precision)
    }
    
    /// `self >= 0`
    internal func isGreaterOrEqualZero(precision: Double = Self.defaultPrecision) -> Bool {
        return self.isGreaterOrEqual(to: 0.0, precision: precision)
    }
    
}

/// Override any functions with the same signature
extension Double {
    
    /// `self < x`
    internal func isLess(than x: Double) -> Bool {
        return self.isLess(than: x, precision: Self.defaultPrecision)
    }
    
    /// `self < x`
    internal func isLess(than x: Float) -> Bool {
        return self.isLess(than: Double(x))
    }
    
    /// `self < x`
    internal func isLess(than x: CGFloat) -> Bool {
        return self.isLess(than: Double(x))
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: Double) -> Bool {
        return self.isLessOrEqual(to: x, precision: Self.defaultPrecision)
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: Float) -> Bool {
        return self.isLessOrEqual(to: Double(x))
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: CGFloat) -> Bool {
        return self.isLessOrEqual(to: Double(x))
    }
    
    /// `self > x`
    internal func isGreater(than x: Double) -> Bool {
        return self.isGreater(than: x, precision: Self.defaultPrecision)
    }
    
    /// `self > x`
    internal func isGreater(than x: Float) -> Bool {
        return self.isGreater(than: Double(x))
    }
    
    /// `self > x`
    internal func isGreater(than x: CGFloat) -> Bool {
        return self.isGreater(than: Double(x))
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: Double) -> Bool {
        return self.isGreaterOrEqual(to: x, precision: Self.defaultPrecision)
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: Float) -> Bool {
        return self.isGreaterOrEqual(to: Double(x))
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: CGFloat) -> Bool {
        return self.isGreaterOrEqual(to: Double(x))
    }
    
    /// `self == x`
    internal func isEqual(to x: Double) -> Bool {
        return self.isEqual(to: x, precision: Self.defaultPrecision)
    }
    
    /// `self == x`
    internal func isEqual(to x: Float) -> Bool {
        return self.isEqual(to: Double(x))
    }
    
    /// `self == x`
    internal func isEqual(to x: CGFloat) -> Bool {
        return self.isEqual(to: Double(x))
    }
    
    /// `self == 0`
    internal func isZero() -> Bool {
        return self.isZero(precision: Self.defaultPrecision)
    }
    
    /// `self < 0`
    internal func isLessThanZero() -> Bool {
        return self.isLessThanZero(precision: Self.defaultPrecision)
    }
    
    /// `self <= 0`
    internal func isLessOrEqualZero() -> Bool {
        return self.isLessOrEqualZero(precision: Self.defaultPrecision)
    }
    
    /// `self > 0`
    internal func isGreaterThanZero() -> Bool {
        return self.isGreaterThanZero(precision: Self.defaultPrecision)
    }
    
    /// `self >= 0`
    internal func isGreaterOrEqualZero() -> Bool {
        return self.isGreaterOrEqualZero(precision: Self.defaultPrecision)
    }
    
}

extension Float {
    
    internal static let defaultPrecision: Float = 1e-5
    
    /// `self < x`
    internal func isLess(than x: Float, precision: Float = Self.defaultPrecision) -> Bool {
        return (x - self > precision)
    }
    
    /// `self < x`
    internal func isLess(than x: Double, precision: Float = Self.defaultPrecision) -> Bool {
        return self.isLess(than: Float(x), precision: precision)
    }
    
    /// `self < x`
    internal func isLess(than x: CGFloat, precision: Float = Self.defaultPrecision) -> Bool {
        return self.isLess(than: Float(x), precision: precision)
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: Float, precision: Float = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: x, precision: precision) || self.isLess(than: x, precision: precision)
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: Double, precision: Float = Self.defaultPrecision) -> Bool {
        return self.isLessOrEqual(to: Float(x), precision: precision)
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: CGFloat, precision: Float = Self.defaultPrecision) -> Bool {
        return self.isLessOrEqual(to: Float(x), precision: precision)
    }
    
    /// `self > x`
    internal func isGreater(than x: Float, precision: Float = Self.defaultPrecision) -> Bool {
        return (self - x > precision)
    }
    
    /// `self > x`
    internal func isGreater(than x: Double, precision: Float = Self.defaultPrecision) -> Bool {
        return self.isGreater(than: Float(x), precision: precision)
    }
    
    /// `self > x`
    internal func isGreater(than x: CGFloat, precision: Float = Self.defaultPrecision) -> Bool {
        return self.isGreater(than: Float(x), precision: precision)
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: Float, precision: Float = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: x, precision: precision) || self.isGreater(than: x, precision: precision)
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: Double, precision: Float = Self.defaultPrecision) -> Bool {
        return self.isGreaterOrEqual(to: Float(x), precision: precision)
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: CGFloat, precision: Float = Self.defaultPrecision) -> Bool {
        return self.isGreaterOrEqual(to: Float(x), precision: precision)
    }
    
    /// `self == x`
    internal func isEqual(to x: Float, precision: Float = Self.defaultPrecision) -> Bool {
        return (abs(self - x) <= precision)
    }
    
    /// `self == x`
    internal func isEqual(to x: Double, precision: Float = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: Float(x), precision: precision)
    }
    
    /// `self == x`
    internal func isEqual(to x: CGFloat, precision: Float = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: Float(x), precision: precision)
    }
    
    /// `self == 0`
    internal func isZero(precision: Float = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: 0.0, precision: precision)
    }
    
    /// `self < 0`
    internal func isLessThanZero(precision: Float = Self.defaultPrecision) -> Bool {
        return self.isLess(than: 0.0, precision: precision)
    }
    
    /// `self <= 0`
    internal func isLessOrEqualZero(precision: Float = Self.defaultPrecision) -> Bool {
        return self.isLessOrEqual(to: 0.0, precision: precision)
    }
    
    /// `self > 0`
    internal func isGreaterThanZero(precision: Float = Self.defaultPrecision) -> Bool {
        return self.isGreater(than: 0.0, precision: precision)
    }
    
    /// `self >= 0`
    internal func isGreaterOrEqualZero(precision: Float = Self.defaultPrecision) -> Bool {
        return self.isGreaterOrEqual(to: 0.0, precision: precision)
    }
    
}

/// Override any functions with the same signature
extension Float {
    
    /// `self < x`
    internal func isLess(than x: Float) -> Bool {
        return self.isLess(than: x, precision: Self.defaultPrecision)
    }
    
    /// `self < x`
    internal func isLess(than x: Double) -> Bool {
        return self.isLess(than: Float(x))
    }
    
    /// `self < x`
    internal func isLess(than x: CGFloat) -> Bool {
        return self.isLess(than: Float(x))
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: Float) -> Bool {
        return self.isLessOrEqual(to: x, precision: Self.defaultPrecision)
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: Double) -> Bool {
        return self.isLessOrEqual(to: Float(x))
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: CGFloat) -> Bool {
        return self.isLessOrEqual(to: Float(x))
    }
    
    /// `self > x`
    internal func isGreater(than x: Float) -> Bool {
        return self.isGreater(than: x, precision: Self.defaultPrecision)
    }
    
    /// `self > x`
    internal func isGreater(than x: Double) -> Bool {
        return self.isGreater(than: Float(x))
    }
    
    /// `self > x`
    internal func isGreater(than x: CGFloat) -> Bool {
        return self.isGreater(than: Float(x))
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: Float) -> Bool {
        return self.isGreaterOrEqual(to: x, precision: Self.defaultPrecision)
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: Double) -> Bool {
        return self.isGreaterOrEqual(to: Float(x))
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: CGFloat) -> Bool {
        return self.isGreaterOrEqual(to: Float(x))
    }
    
    /// `self == x`
    internal func isEqual(to x: Float) -> Bool {
        return self.isEqual(to: x, precision: Self.defaultPrecision)
    }
    
    /// `self == x`
    internal func isEqual(to x: Double) -> Bool {
        return self.isEqual(to: Float(x))
    }
    
    /// `self == x`
    internal func isEqual(to x: CGFloat) -> Bool {
        return self.isEqual(to: Float(x))
    }
    
    /// `self == 0`
    internal func isZero() -> Bool {
        return self.isZero(precision: Self.defaultPrecision)
    }
    
    /// `self < 0`
    internal func isLessThanZero() -> Bool {
        return self.isLessThanZero(precision: Self.defaultPrecision)
    }
    
    /// `self <= 0`
    internal func isLessOrEqualZero() -> Bool {
        return self.isLessOrEqualZero(precision: Self.defaultPrecision)
    }
    
    /// `self > 0`
    internal func isGreaterThanZero() -> Bool {
        return self.isGreaterThanZero(precision: Self.defaultPrecision)
    }
    
    /// `self >= 0`
    internal func isGreaterOrEqualZero() -> Bool {
        return self.isGreaterOrEqualZero(precision: Self.defaultPrecision)
    }
    
}

extension CGFloat {
    
    internal static let defaultPrecision: CGFloat = 1e-5
    
    /// `self < x`
    internal func isLess(than x: CGFloat, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return (x - self > precision)
    }
    
    /// `self < x`
    internal func isLess(than x: Float, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isLess(than: CGFloat(x), precision: precision)
    }
    
    /// `self < x`
    internal func isLess(than x: Double, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isLess(than: CGFloat(x), precision: precision)
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: CGFloat, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: x, precision: precision) || self.isLess(than: x, precision: precision)
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: Float, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isLessOrEqual(to: CGFloat(x), precision: precision)
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: Double, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isLessOrEqual(to: CGFloat(x), precision: precision)
    }
    
    /// `self > x`
    internal func isGreater(than x: CGFloat, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return (self - x > precision)
    }
    
    /// `self > x`
    internal func isGreater(than x: Float, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isGreater(than: CGFloat(x), precision: precision)
    }
    
    /// `self > x`
    internal func isGreater(than x: Double, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isGreater(than: CGFloat(x), precision: precision)
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: CGFloat, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: x, precision: precision) || self.isGreater(than: x, precision: precision)
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: Float, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isGreaterOrEqual(to: CGFloat(x), precision: precision)
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: Double, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isGreaterOrEqual(to: CGFloat(x), precision: precision)
    }
    
    /// `self == x`
    internal func isEqual(to x: CGFloat, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return (abs(self - x) <= precision)
    }
    
    /// `self == x`
    internal func isEqual(to x: Float, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: CGFloat(x), precision: precision)
    }
    
    /// `self == x`
    internal func isEqual(to x: Double, precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: CGFloat(x), precision: precision)
    }
    
    /// `self == 0`
    internal func isZero(precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isEqual(to: 0.0, precision: precision)
    }
    
    /// `self < 0`
    internal func isLessThanZero(precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isLess(than: 0.0, precision: precision)
    }
    
    /// `self <= 0`
    internal func isLessOrEqualZero(precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isLessOrEqual(to: 0.0, precision: precision)
    }
    
    /// `self > 0`
    internal func isGreaterThanZero(precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isGreater(than: 0.0, precision: precision)
    }
    
    /// `self >= 0`
    internal func isGreaterOrEqualZero(precision: CGFloat = Self.defaultPrecision) -> Bool {
        return self.isGreaterOrEqual(to: 0.0, precision: precision)
    }
    
}

/// Override any functions with the same signature
extension CGFloat {
    
    /// `self < x`
    internal func isLess(than x: CGFloat) -> Bool {
        return self.isLess(than: x, precision: Self.defaultPrecision)
    }
    
    /// `self < x`
    internal func isLess(than x: Float) -> Bool {
        return self.isLess(than: CGFloat(x))
    }
    
    /// `self < x`
    internal func isLess(than x: Double) -> Bool {
        return self.isLess(than: CGFloat(x))
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: CGFloat) -> Bool {
        return self.isLessOrEqual(to: x, precision: Self.defaultPrecision)
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: Float) -> Bool {
        return self.isLessOrEqual(to: CGFloat(x))
    }
    
    /// `self <= x`
    internal func isLessOrEqual(to x: Double) -> Bool {
        return self.isLessOrEqual(to: CGFloat(x))
    }
    
    /// `self > x`
    internal func isGreater(than x: CGFloat) -> Bool {
        return self.isGreater(than: x, precision: Self.defaultPrecision)
    }
    
    /// `self > x`
    internal func isGreater(than x: Float) -> Bool {
        return self.isGreater(than: CGFloat(x))
    }
    
    /// `self > x`
    internal func isGreater(than x: Double) -> Bool {
        return self.isGreater(than: CGFloat(x))
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: CGFloat) -> Bool {
        return self.isGreaterOrEqual(to: x, precision: Self.defaultPrecision)
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: Float) -> Bool {
        return self.isGreaterOrEqual(to: CGFloat(x))
    }
    
    /// `self >= x`
    internal func isGreaterOrEqual(to x: Double) -> Bool {
        return self.isGreaterOrEqual(to: CGFloat(x))
    }
    
    /// `self == x`
    internal func isEqual(to x: CGFloat) -> Bool {
        return self.isEqual(to: x, precision: Self.defaultPrecision)
    }
    
    /// `self == x`
    internal func isEqual(to x: Float) -> Bool {
        return self.isEqual(to: CGFloat(x))
    }
    
    /// `self == x`
    internal func isEqual(to x: Double) -> Bool {
        return self.isEqual(to: CGFloat(x))
    }
    
    /// `self == 0`
    internal func isZero() -> Bool {
        return self.isZero(precision: Self.defaultPrecision)
    }
    
    /// `self < 0`
    internal func isLessThanZero() -> Bool {
        return self.isLessThanZero(precision: Self.defaultPrecision)
    }
    
    /// `self <= 0`
    internal func isLessOrEqualZero() -> Bool {
        return self.isLessOrEqualZero(precision: Self.defaultPrecision)
    }
    
    /// `self > 0`
    internal func isGreaterThanZero() -> Bool {
        return self.isGreaterThanZero(precision: Self.defaultPrecision)
    }
    
    /// `self >= 0`
    internal func isGreaterOrEqualZero() -> Bool {
        return self.isGreaterOrEqualZero(precision: Self.defaultPrecision)
    }
    
}
