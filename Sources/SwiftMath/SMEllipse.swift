//
//  SMEllipse.swift
//
//
//  Created by Andre Pham on 3/3/2024.
//

import Foundation
import CoreGraphics

open class SMEllipse: SMClonable, Equatable {
    
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
        return SM.isEqual(self.boundingBox.width, self.boundingBox.height)
    }
    
    public init(boundingBox: SMRect) {
        self.boundingBox = boundingBox
    }
    
    public required init(_ original: SMEllipse) {
        self.boundingBox = original.boundingBox.clone()
    }
    
    // MARK: - Transformations
    
    public func translate(by point: SMPoint) {
        self.boundingBox.translate(by: point)
    }
    
    /// Rotates the center of this ellipse around a point
    public func rotate(around center: SMPoint, by angle: SMAngle) {
        self.boundingBox.rotate(around: center, by: angle)
    }
    
    public func scale(from point: SMPoint, by factor: Double) {
        self.boundingBox.scale(from: point, by: factor)
    }
    
    // MARK: - Operations
    
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
