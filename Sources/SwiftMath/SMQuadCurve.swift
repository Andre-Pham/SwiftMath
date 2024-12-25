//
//  SMQuadCurve.swift
//
//
//  Created by Andre Pham on 29/2/2024.
//

import Foundation
import CoreGraphics

/// Represents a quad curve.
public struct SMQuadCurve: SMTransformable {
    
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
    
    // MARK: - Transformations
    
    public mutating func translate(by point: SMPoint) {
        self.origin += point
        self.end += point
        self.controlPoint += point
    }
    
    public mutating func translateCenter(to point: SMPoint) {
        let center = self.boundingBox.center
        self.translate(by: point - center)
    }
    
    public mutating func rotate(around center: SMPoint, by angle: SMAngle) {
        self.origin.rotate(around: center, by: angle)
        self.end.rotate(around: center, by: angle)
        self.controlPoint.rotate(around: center, by: angle)
    }
    
    public mutating func scale(from point: SMPoint, scale: Double) {
        self.translate(by: point * -1)
        self.origin *= scale
        self.end *= scale
        self.controlPoint *= scale
        self.translate(by: point)
    }
    
    // MARK: - Operations
    
    public static func + (left: SMQuadCurve, right: SMPoint) -> SMQuadCurve {
        return SMQuadCurve(
            origin: left.origin + right,
            controlPoint: left.controlPoint + right,
            end: left.end + right
        )
    }

    public static func += (left: inout SMQuadCurve, right: SMPoint) {
        left = left + right
    }

    public static func - (left: SMQuadCurve, right: SMPoint) -> SMQuadCurve {
        return SMQuadCurve(
            origin: left.origin - right,
            controlPoint: left.controlPoint - right,
            end: left.end - right
        )
    }

    public static func -= (left: inout SMQuadCurve, right: SMPoint) {
        left = left - right
    }
    
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
