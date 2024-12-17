//
//  SMQuadCurve.swift
//
//
//  Created by Andre Pham on 29/2/2024.
//

import Foundation
import CoreGraphics

/// Represents a quad curve.
open class SMQuadCurve: SMClonable, Equatable {
    
    // MARK: - Properties
    
    /// The origin the curve
    public var origin: SMPoint
    /// The control point of the curve
    public var controlPoint: SMPoint
    /// The end of the curve
    public var end: SMPoint
    /// True if the quad curve's length is zero
    public var lengthIsZero: Bool {
        return (
            self.origin == self.controlPoint
            && self.origin == self.end
        )
    }
    /// The bounding box that contains the entire curve
    public var boundingBox: SMRect {
        return SMRect(self.cgPath.boundingBoxOfPath)
    }
    
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
    
    // MARK: - Transformations
    
    public func translate(by point: SMPoint) {
        self.origin += point
        self.end += point
        self.controlPoint += point
    }
    
    public func rotate(around center: SMPoint, by angle: SMAngle) {
        self.origin.rotate(around: center, by: angle)
        self.end.rotate(around: center, by: angle)
        self.controlPoint.rotate(around: center, by: angle)
    }
    
    public func scale(from point: SMPoint, by factor: Double) {
        self.translate(by: point * -1)
        self.origin *= factor
        self.end *= factor
        self.controlPoint *= factor
        self.translate(by: point)
    }
    
    // MARK: - Operations
    
    public static func == (lhs: SMQuadCurve, rhs: SMQuadCurve) -> Bool {
        return lhs.origin == rhs.origin && lhs.end == rhs.end && lhs.controlPoint == rhs.controlPoint
    }
    
    // MARK: - Core Graphics
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        path.move(to: self.origin.cgPoint)
        path.addQuadCurve(to: self.end.cgPoint, control: self.controlPoint.cgPoint)
        return path
    }
    
}
