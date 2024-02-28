//
//  SMBezierCurve.swift
//  
//
//  Created by Andre Pham on 29/2/2024.
//

import Foundation

open class SMBezierCurve: SMClonable {
    
    // MARK: - Properties
    
    /// The origin the curve
    public var origin: SMPoint
    /// The origin's control point of the curve
    public var originControlPoint: SMPoint
    /// The end's control point of the curve
    public var endControlPoint: SMPoint
    /// The end of the curve
    public var end: SMPoint
    
    // MARK: - Constructors
    
    public init(origin: SMPoint, originControlPoint: SMPoint, endControlPoint: SMPoint, end: SMPoint) {
        self.origin = origin
        self.originControlPoint = originControlPoint
        self.endControlPoint = endControlPoint
        self.end = end
    }
    
    public required init(_ original: SMBezierCurve) {
        self.origin = original.origin.clone()
        self.originControlPoint = original.originControlPoint.clone()
        self.endControlPoint = original.endControlPoint.clone()
        self.end = original.end.clone()
    }
    
}
