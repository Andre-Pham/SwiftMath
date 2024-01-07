//
//  SMLine.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

public class SMLine: SMClonable {
    
    // MARK: - Properties
    
    /// The origin the line
    public var origin: SMPoint
    /// The end of the line
    public var end: SMPoint
    /// The line midpoint
    public var midPoint: SMPoint {
        let midX = (self.origin.x + self.end.x)/2.0
        let midY = (self.origin.y + self.end.y)/2.0
        return SMPoint(x: midX, y: midY)
    }
    /// The line length
    public var length: Double {
        let dx = self.end.x - self.origin.x
        let dy = self.end.y - self.origin.y
        return sqrt(dx * dx + dy * dy)
    }
    /// The slope of the line
    public var gradient: Double? {
        guard !SM.isEqual(self.origin.x, self.end.x) else {
            return nil
        }
        return (self.end.y - self.origin.y) / (self.end.x - self.origin.x)
    }
    
    // MARK: - Constructors
    
    public init(origin: SMPoint, end: SMPoint) {
        self.origin = origin.clone()
        self.end = end.clone()
    }
    
    public required init(_ original: SMLine) {
        self.origin = original.origin.clone()
        self.end = original.end.clone()
    }
    
    // MARK: - Functions
    
    public static func + (left: SMLine, right: SMPoint) -> SMLine {
        return SMLine(origin: left.origin + right, end: left.end + right)
    }

    public static func += (left: inout SMLine, right: SMPoint) {
        left = left + right
    }

    public static func - (left: SMLine, right: SMPoint) -> SMLine {
        return SMLine(origin: left.origin - right, end: left.end - right)
    }

    public static func -= (left: inout SMLine, right: SMPoint) {
        left = left - right
    }
    
}
