//
//  SMBezierCurve.swift
//  
//
//  Created by Andre Pham on 29/2/2024.
//

import Foundation
import CoreGraphics

open class SMBezierCurve: SMClonable {
    
    // MARK: - Properties
    
    /// The origin the curve
    public var origin: SMPoint
    /// The origin's control point of the curve
    public var originControlPoint: SMPoint
    /// The end of the curve
    public var end: SMPoint
    /// The end's control point of the curve
    public var endControlPoint: SMPoint
    
    // MARK: - Constructors
    
    public init(origin: SMPoint, originControlPoint: SMPoint, end: SMPoint, endControlPoint: SMPoint) {
        self.origin = origin
        self.originControlPoint = originControlPoint
        self.end = end
        self.endControlPoint = endControlPoint
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
    
    // MARK: - Core Graphics
    
    public var cgPath: CGPath {
        var path = CGMutablePath()
        path.move(to: self.origin.cgPoint)
        path.addCurve(to: self.end.cgPoint, control1: self.originControlPoint.cgPoint, control2: self.endControlPoint.cgPoint)
        return path
    }
    
}
