//
//  SMLine.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

class SMLine: SMClonable {
    
    // MARK: - Properties
    
    /// The origin the line
    public var origin: SMPoint
    /// The end of the line
    public var end: SMPoint
    /// The line midpoint
    public var midPoint: SMPoint {
        let midX = (origin.x + end.x)/2.0
        let midY = (origin.y + end.y)/2.0
        return SMPoint(x: midX, y: midY)
    }
    /// The line length
    public var length: Double {
        let dx = end.x - origin.x
        let dy = end.y - origin.y
        return sqrt(dx * dx + dy * dy)
    }
    /// The slope of the line
    public var gradient: Double {
        return (end.y - origin.y) / (end.x - origin.x)
    }
    
    // MARK: - Constructors
    
    init(origin: SMPoint, end: SMPoint) {
        self.origin = origin.clone()
        self.end = end.clone()
    }
    
    required init(_ original: SMLine) {
        self.origin = original.origin.clone()
        self.end = original.end.clone()
    }
    
    // MARK: - Functions
    
}
