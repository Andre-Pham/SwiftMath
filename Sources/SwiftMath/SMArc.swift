//
//  SMArc.swift
//
//
//  Created by Andre Pham on 7/1/2024.
//

import Foundation
import CoreGraphics

/// Represents a segment of a circle's perimeter, defined by two points on the circumference and the path between them along the circle.
open class SMArc: SMClonable {
    
    /// The center of the arc
    public var center: SMPoint
    /// The radius of the arc
    public var radius: Double
    /// True if a zero central angles completes the circle; false when a zero central angle is an empty arc
    public var fullArcWhenZeroCentralAngle: Bool
    /// The internal start angle
    private var _startAngle: SMAngle
    /// The angle of the start point of the arc (always normalized)
    public var startAngle: SMAngle {
        get { return self._startAngle.normalized }
        set { self._startAngle = newValue }
    }
    /// The internal end angle
    private var _endAngle: SMAngle
    /// The angle of the end point of the arc (always normalized)
    public var endAngle: SMAngle {
        get { return self._endAngle.normalized }
        set { self._endAngle = newValue }
    }
    /// If the arc forms a full circle (requires fullArcWhenZeroCentralAngle to be true)
    public var isFullCircle: Bool {
        return self.fullArcWhenZeroCentralAngle && SM.isEqual(self.startAngle.radians, self.endAngle.radians)
    }
    /// The length of the arc's line
    public var length: Double {
        guard !self.isFullCircle else {
            return self.circumference
        }
        let reference = self.clone()
        reference.rotate(by: reference.startAngle * -1)
        let angleDifference = reference.endAngle - reference.startAngle
        return reference.radius*angleDifference.radians
    }
    /// The circumference (length) of the arc's defining circle (full circle)
    public var circumference: Double {
        return 2.0 * .pi * self.radius
    }
    /// The start point of the arc
    public var startPoint: SMPoint {
        let x = self.center.x + self.radius * cos(self.startAngle.radians)
        let y = self.center.y + self.radius * sin(self.startAngle.radians)
        return SMPoint(x: x, y: y)
    }
    /// The end point of the arc
    public var endPoint: SMPoint {
        let x = self.center.x + self.radius * cos(self.endAngle.radians)
        let y = self.center.y + self.radius * sin(self.endAngle.radians)
        return SMPoint(x: x, y: y)
    }
    /// The straight line between the start point and end point of the arc
    public var chord: SMLineSegment {
        return SMLineSegment(origin: self.startPoint, end: self.endPoint)
    }
    /// The angle between the start angle and the end angle
    public var centralAngle: SMAngle {
        let reference = self.clone()
        reference.rotate(by: reference.startAngle * -1)
        return (reference.endAngle - reference.startAngle).normalized
    }
    /// Bounding box of the arc
    public var boundingBox: SMRect {
        guard !self.isFullCircle else {
            return SMRect(center: self.center, width: self.radius*2.0, height: self.radius*2.0)
        }
        var minX = min(self.startPoint.x, self.endPoint.x)
        var maxX = max(self.startPoint.x, self.endPoint.x)
        var minY = min(self.startPoint.y, self.endPoint.y)
        var maxY = max(self.startPoint.y, self.endPoint.y)
        let angles = [SMAngle(degrees: 0), SMAngle(degrees: 90), SMAngle(degrees: 180), SMAngle(degrees: 270)]
        for angle in angles {
            // Check if the arc passes through this angle
            let isBetween = SM.isLessOrEqual(self.startAngle.radians, angle.radians) && SM.isLessOrEqual(angle.radians, self.endAngle.radians)
            let crosses = SM.isGreater(self.startAngle.radians, self.endAngle.radians) && (SM.isGreaterOrEqual(angle.radians, self.startAngle.radians) || SM.isLessOrEqual(angle.radians, self.endAngle.radians))
            if isBetween || crosses {
                let x = self.center.x + self.radius * cos(angle.radians)
                let y = self.center.y + self.radius * sin(angle.radians)
                minX = min(minX, x)
                maxX = max(maxX, x)
                minY = min(minY, y)
                maxY = max(maxY, y)
            }
        }
        return SMRect(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
    }
    
    public init(
        center: SMPoint = SMPoint(),
        radius: Double,
        startAngle: SMAngle,
        endAngle: SMAngle,
        fullArcWhenZeroCentralAngle: Bool = false
    ) {
        self.center = center
        self.radius = radius
        self.fullArcWhenZeroCentralAngle = fullArcWhenZeroCentralAngle
        self._startAngle = startAngle
        self._endAngle = endAngle
    }
    
    public required init(_ original: SMArc) {
        self.center = original.center.clone()
        self.radius = original.radius
        self.fullArcWhenZeroCentralAngle = original.fullArcWhenZeroCentralAngle
        self._startAngle = original._startAngle.clone()
        self._endAngle = original._endAngle.clone()
    }
    
    // MARK: - Functions
    
    /// Rotates the arc counter-clockwise around its center by a certain angle
    /// - Parameters:
    ///   - angle: The angle to rotate by
    public func rotate(by angle: SMAngle) {
        self.startAngle += angle
        self.endAngle += angle
    }
    
    /// Extend or contract the arc's length by a certain amount. Adjusts the arc's end.
    /// If the length is negative and has a magnitude greater than the arc's original length, the arc begins extending in the opposite direction.
    /// - Parameters:
    ///   - length: The length to extend (+) or contract (-) by
    public func adjustLength(by length: Double) {
        if SM.isLessZero(self.length + length) {
            if SM.isGreater(abs(length), self.circumference) {
                // WARNING: Recursion is used here
                self.adjustLength(by: length.truncatingRemainder(dividingBy: self.circumference))
            } else {
                let length = self.circumference + (self.length + length).truncatingRemainder(dividingBy: self.circumference)
                let rotation = self.startAngle.clone()
                self.rotate(by: rotation * -1)
                self.endAngle = SMAngle(radians: length/self.radius)
                let temp = self.startAngle
                self.startAngle = self.endAngle
                self.endAngle = temp
                self.rotate(by: rotation)
            }
        } else {
            self.setLength(to: self.length + length)
        }
    }
    
    /// Set the arc's length. Adjusts the arc's end.
    /// Setting a negative length is valid - the end angle continues in the opposite direction.
    /// - Parameters:
    ///   - length: The new length (negative to go in the opposite direction from the origin point)
    public func setLength(to length: Double) {
        let length = length.truncatingRemainder(dividingBy: self.circumference)
        guard !SM.isZero(length) else {
            self.endAngle = self.startAngle.clone()
            return
        }
        let rotation = self.startAngle.clone()
        self.rotate(by: rotation * -1)
        if SM.isLessZero(length) {
            self.endAngle = SMAngle(radians: abs(length)/self.radius)
            self.rotate(by: self.centralAngle * -1)
        } else {
            self.endAngle = SMAngle(radians: length/self.radius)
        }
        self.rotate(by: rotation)
    }
    
    // MARK: - Transformations
    
    public func translate(by point: SMPoint) {
        self.center += point
    }
    
    public func rotate(around center: SMPoint, by angle: SMAngle) {
        self.center.rotate(around: center, by: angle)
    }
    
    public func scale(from point: SMPoint, by factor: Double) {
        self.translate(by: point * -1)
        self.center *= factor
        self.radius *= factor
        self.translate(by: point)
    }
    
    // MARK: - Core Graphics
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        if self.isFullCircle {
            path.addEllipse(in: self.boundingBox.cgRect)
        } else {
            path.addArc(
                center: self.center.cgPoint,
                radius: self.radius,
                startAngle: self.startAngle.radians,
                endAngle: self.endAngle.radians,
                clockwise: false
            )
        }
        return path
    }
    
}
