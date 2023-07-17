//
//  Double.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

extension Double {
    
    func toString(decimalPlaces: Int = 0) -> String {
        return NSString(format: "%.\(decimalPlaces)f" as NSString, self) as String
    }
    
    func toRoundedInt() -> Int {
        return Int(Darwin.round(self))
    }
    
    func compound(multiply: Double, index: Double) -> Double {
        return self*pow(multiply, index)
    }
    
    func compound(multiply: Double, index: Int) -> Double {
        return self.compound(multiply: multiply, index: Double(index))
    }
    
    /// Retrieves the nearest double that's a multiple of x.
    /// Example:
    /// ``` 0.32.nearest(0.05) -> 0.3
    ///     0.33.nearest(0.05) -> 0.35
    /// ```
    /// - Parameters:
    ///   - x: The magnitude that the return value has to be a multiple of.
    /// - Returns: The nearest double `y` where `y%x == 0`
    func nearest(_ x: Double) -> Double {
        let decimals = String(x).split(separator: ".")[1]
        let decimalCount = decimals == "0" ? 0 : decimals.count
        let remainder = self.truncatingRemainder(dividingBy: x)
        let divisor = pow(10.0, Double(decimalCount))
        let lower = Darwin.round((self - remainder)*divisor)/divisor
        let upper = Darwin.round((self - remainder)*divisor)/divisor + x
        return (self - lower < upper - self) ? lower : upper
    }
    
    /// Round to x decimal places.
    /// Example: `0.545.rounded(decimalPlaces: 1) -> 0.5`
    /// - Parameters:
    ///   - decimalPlaces: The number of digits after the decimal point
    /// - Returns: The rounded double
    func rounded(decimalPlaces: Int) -> Double {
        let multiplier = pow(10.0, Double(decimalPlaces))
        return Darwin.round(self*multiplier)/multiplier
    }
    
}
