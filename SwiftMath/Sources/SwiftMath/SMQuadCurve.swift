//
//  SMQuadCurve.swift
//
//
//  Created by Andre Pham on 29/2/2024.
//

import Foundation

open class SMQuadCurve: SMClonable {
    
    // MARK: - Properties
    
    /// The origin the curve
    public var origin: SMPoint
    /// The control point of the curve
    public var controlPoint: SMPoint
    /// The end of the curve
    public var end: SMPoint
    
    // MARK: - Constructors
    
    public init(origin: SMPoint, controlPoint: SMPoint, end: SMPoint) {
        self.origin = origin
        self.controlPoint = controlPoint
        self.end = end
    }
    
    public required init(_ original: SMQuadCurve) {
        self.origin = original.origin.clone()
        self.controlPoint = original.controlPoint.clone()
        self.end = original.end.clone()
    }
    
}
