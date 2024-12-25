//
//  SMBezierCurve.swift
//  
//
//  Created by Andre Pham on 29/2/2024.
//

import Foundation
import CoreGraphics

/// Represents a bezier curve.
public struct SMBezierCurve: SMTransformable {
    
    // MARK: - Properties
    
    /// The origin the curve
    public var origin: SMPoint
    /// The origin's control point of the curve
    public var originControlPoint: SMPoint
    /// The end of the curve
    public var end: SMPoint
    /// The end's control point of the curve
    public var endControlPoint: SMPoint
    /// True if the bezier curve's length is zero
    public var lengthIsZero: Bool {
        return (
            self.origin == self.originControlPoint
            && self.origin == self.end
            && self.origin == self.endControlPoint
        )
    }
    /// The bounding box that contains the entire curve
    public var boundingBox: SMRect {
        return SMRect(self.cgPath.boundingBoxOfPath)
    }
    
    // MARK: - Constructors
    
    public init(origin: SMPoint, originControlPoint: SMPoint, end: SMPoint, endControlPoint: SMPoint) {
        self.origin = origin
        self.originControlPoint = originControlPoint
        self.end = end
        self.endControlPoint = endControlPoint
    }
    
    // MARK: - Transformations
    
    public mutating func translate(by point: SMPoint) {
        self.origin += point
        self.end += point
        self.originControlPoint += point
        self.endControlPoint += point
    }
    
    public mutating func translateCenter(to point: SMPoint) {
        let center = self.boundingBox.center
        self.translate(by: point - center)
    }
    
    public mutating func rotate(around center: SMPoint, by angle: SMAngle) {
        self.origin.rotate(around: center, by: angle)
        self.end.rotate(around: center, by: angle)
        self.originControlPoint.rotate(around: center, by: angle)
        self.endControlPoint.rotate(around: center, by: angle)
    }
    
    public mutating func scale(from point: SMPoint, scale: Double) {
        self.translate(by: point * -1)
        self.origin *= scale
        self.end *= scale
        self.originControlPoint *= scale
        self.endControlPoint *= scale
        self.translate(by: point)
    }
    
    // MARK: - Operations
    
    public static func + (left: SMBezierCurve, right: SMPoint) -> SMBezierCurve {
        return SMBezierCurve(
            origin: left.origin + right,
            originControlPoint: left.originControlPoint + right,
            end: left.end + right,
            endControlPoint: left.endControlPoint + right
        )
    }

    public static func += (left: inout SMBezierCurve, right: SMPoint) {
        left = left + right
    }

    public static func - (left: SMBezierCurve, right: SMPoint) -> SMBezierCurve {
        return SMBezierCurve(
            origin: left.origin - right,
            originControlPoint: left.originControlPoint - right,
            end: left.end - right,
            endControlPoint: left.endControlPoint - right
        )
    }

    public static func -= (left: inout SMBezierCurve, right: SMPoint) {
        left = left - right
    }
    
    public static func == (lhs: SMBezierCurve, rhs: SMBezierCurve) -> Bool {
        return lhs.origin == rhs.origin && lhs.end == rhs.end && lhs.originControlPoint == rhs.originControlPoint && lhs.endControlPoint == rhs.endControlPoint
    }
    
    // MARK: - Core Graphics
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        path.move(to: self.origin.cgPoint)
        path.addCurve(to: self.end.cgPoint, control1: self.originControlPoint.cgPoint, control2: self.endControlPoint.cgPoint)
        return path
    }
    
}
