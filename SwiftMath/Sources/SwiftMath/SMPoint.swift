//
//  SMPoint.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

class SMPoint: SMClonable, Equatable {
    
    // MARK: - Properties
    
    public var x: Double
    public var y: Double
    
    // MARK: - Constructors
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    convenience init() {
        self.init(x: 0.0, y: 0.0)
    }
    
    convenience init(x: Float, y: Float) {
        self.init(x: Double(x), y: Double(y))
    }
    
    required init(_ original: SMPoint) {
        self.x = original.x
        self.y = original.y
    }
    
    // MARK: - Functions
    
    // MARK: - Operations

    static func + (left: SMPoint, right: SMPoint) -> SMPoint {
        return SMPoint(x: left.x + right.x, y: left.y + right.y)
    }

    static func += (left: inout SMPoint, right: SMPoint) {
        left = left + right
    }

    static func - (left: SMPoint, right: SMPoint) -> SMPoint {
        return SMPoint(x: left.x - right.x, y: left.y - right.y)
    }

    static func -= (left: inout SMPoint, right: SMPoint) {
        left = left - right
    }

    static func * (point: SMPoint, scalar: Double) -> SMPoint {
        return SMPoint(x: point.x * scalar, y: point.y * scalar)
    }

    static func *= (point: inout SMPoint, scalar: Double) {
        point = point * scalar
    }

    static func / (point: SMPoint, scalar: Double) -> SMPoint {
        guard scalar != 0 else {
            print("Error: Division by zero.")
            return point
        }
        return SMPoint(x: point.x / scalar, y: point.y / scalar)
    }

    static func /= (point: inout SMPoint, scalar: Double) {
        point = point / scalar
    }

    static func == (lhs: SMPoint, rhs: SMPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    // MARK: - Core Graphics
    
    public var cgPoint: CGPoint {
        return CGPoint(x: self.x, y: self.y)
    }
    
    init(_ cgPoint: CGPoint) {
        self.x = cgPoint.x
        self.y = cgPoint.y
    }
    
}
