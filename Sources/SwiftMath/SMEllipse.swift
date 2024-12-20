//
//  SMEllipse.swift
//
//
//  Created by Andre Pham on 3/3/2024.
//

import Foundation
import CoreGraphics

/// Represents an ellipse.
public final class SMEllipse: SMClonable, SMTransformable {
    
    public var boundingBox: SMRect
    public var isValid: Bool {
        return self.boundingBox.isValid
    }
    public var minRadius: Double {
        return min(self.boundingBox.width, self.boundingBox.height)/2.0
    }
    public var maxRadius: Double {
        return max(self.boundingBox.width, self.boundingBox.height)/2.0
    }
    public var isCircle: Bool {
        return self.boundingBox.width.isEqual(to: self.boundingBox.height)
    }
    public var area: Double {
        return .pi*self.boundingBox.width*self.boundingBox.height/4.0
    }
    public var circumference: Double {
        let a = self.maxRadius
        let b = self.minRadius
        // Ramanujan's approximation for the circumference of an ellipse
        return .pi * (3*(a + b) - sqrt((3*a + b) * (a + 3*b)))
    }

    
    public init(boundingBox: SMRect) {
        self.boundingBox = boundingBox.clone()
    }
    
    public required init(_ original: SMEllipse) {
        self.boundingBox = original.boundingBox.clone()
    }
    
    // MARK: - Transformations
    
    public func translate(by point: SMPoint) {
        self.boundingBox.translate(by: point)
    }
    
    public func translateCenter(to point: SMPoint) {
        self.boundingBox.translateCenter(to: point)
    }
    
    /// Rotates the center of this ellipse around a point
    public func rotate(around center: SMPoint, by angle: SMAngle) {
        self.boundingBox.rotate(around: center, by: angle)
    }
    
    public func scale(from point: SMPoint, scale: Double) {
        self.boundingBox.scale(from: point, scale: scale)
    }
    
    // MARK: - Operations
    
    public static func + (left: SMEllipse, right: SMPoint) -> SMEllipse {
        return SMEllipse(boundingBox: left.boundingBox + right)
    }

    public static func += (left: inout SMEllipse, right: SMPoint) {
        left = left + right
    }

    public static func - (left: SMEllipse, right: SMPoint) -> SMEllipse {
        return SMEllipse(boundingBox: left.boundingBox - right)
    }

    public static func -= (left: inout SMEllipse, right: SMPoint) {
        left = left - right
    }
    
    public static func == (lhs: SMEllipse, rhs: SMEllipse) -> Bool {
        return lhs.boundingBox == rhs.boundingBox
    }
    
    // MARK: - Core Graphics
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        path.addEllipse(in: self.boundingBox.cgRect)
        return path
    }
    
    public var cgPathValidated: CGPath? {
        guard self.isValid else {
            return nil
        }
        return self.cgPath
    }
    
}
