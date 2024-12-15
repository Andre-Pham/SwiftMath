//
//  SMBezierCurve.swift
//  
//
//  Created by Andre Pham on 29/2/2024.
//

import Foundation
import CoreGraphics

/// Represents a bezier curve.
open class SMBezierCurve: SMClonable, Equatable {
    
    // MARK: - Properties
    
    /// The origin the curve
    public var origin: SMPoint
    /// The origin's control point of the curve
    public var originControlPoint: SMPoint
    /// The end of the curve
    public var end: SMPoint
    /// The end's control point of the curve
    public var endControlPoint: SMPoint
    /// True if the bezier curve's length is zero
    public var lengthIsZero: Bool {
        return (
            self.origin == self.originControlPoint
            && self.origin == self.end
            && self.origin == self.endControlPoint
        )
    }
    
    // MARK: - Constructors
    
    public init(origin: SMPoint, originControlPoint: SMPoint, end: SMPoint, endControlPoint: SMPoint) {
        self.origin = origin.clone()
        self.originControlPoint = originControlPoint.clone()
        self.end = end.clone()
        self.endControlPoint = endControlPoint.clone()
    }
    
    public required init(_ original: SMBezierCurve) {
        self.origin = original.origin.clone()
        self.originControlPoint = original.originControlPoint.clone()
        self.end = original.end.clone()
        self.endControlPoint = original.endControlPoint.clone()
    }
    
    // MARK: - Transformations
    
    public func translate(by point: SMPoint) {
        self.origin += point
        self.end += point
        self.originControlPoint += point
        self.endControlPoint += point
    }
    
    public func rotate(around center: SMPoint, by angle: SMAngle) {
        self.origin.rotate(around: center, by: angle)
        self.end.rotate(around: center, by: angle)
        self.originControlPoint.rotate(around: center, by: angle)
        self.endControlPoint.rotate(around: center, by: angle)
    }
    
    public func scale(from point: SMPoint, by factor: Double) {
        self.translate(by: point * -1)
        self.origin *= factor
        self.end *= factor
        self.originControlPoint *= factor
        self.endControlPoint *= factor
        self.translate(by: point)
    }
    
    // MARK: - Operations
    
    public static func == (lhs: SMBezierCurve, rhs: SMBezierCurve) -> Bool {
        return lhs.origin == rhs.origin && lhs.end == rhs.end && lhs.originControlPoint == rhs.originControlPoint && lhs.endControlPoint == rhs.endControlPoint
    }
    
    // MARK: - Core Graphics
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        path.move(to: self.origin.cgPoint)
        path.addCurve(to: self.end.cgPoint, control1: self.originControlPoint.cgPoint, control2: self.endControlPoint.cgPoint)
        return path
    }
    
}
