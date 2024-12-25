//
//  SMArc.swift
//
//
//  Created by Andre Pham on 7/1/2024.
//

import Foundation
import CoreGraphics

/// Represents a segment of a circle's perimeter, defined by two points on the circumference and the path between them along the circle.
public struct SMArc: SMTransformable {
    
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
        return self.fullArcWhenZeroCentralAngle && self.startAngle.radians.isEqual(to: self.endAngle.radians)
    }
    /// The length of the arc's line
    public var length: Double {
        guard !self.isFullCircle else {
            return self.circumference
        }
        var reference = self
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
    /// The mid point of the arc (lies on the arc)
    public var midPoint: SMPoint {
        return self.pointAtProportion(0.5)
    }
    /// The straight line between the start point and end point of the arc
    public var chord: SMLineSegment {
        return SMLineSegment(origin: self.startPoint, end: self.endPoint)
    }
    /// The angle from the start angle to the end angle (the spanning angle)
    public var centralAngle: SMAngle {
        return (self.endAngle - self.startAngle).normalized
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
            let isBetween = self.startAngle.radians.isLessOrEqual(to: angle.radians) && angle.radians.isLessOrEqual(to: self.endAngle.radians)
            let crosses = self.startAngle.radians.isGreater(than: self.endAngle.radians)
                && angle.radians.isGreaterOrEqual(to: self.startAngle.radians)
                || angle.radians.isLessOrEqual(to: self.endAngle.radians)
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
    
    public init(
        point1: SMPoint,
        vertex: SMPoint,
        point2: SMPoint,
        minor: Bool,
        radius: Double,
        fullArcWhenZeroCentralAngle: Bool = false
    ) {
        let angle1 = SMAngle(point1: vertex + SMPoint(x: 1, y: 0), vertex: vertex, point2: point1)
        let angle2 = SMAngle(point1: vertex + SMPoint(x: 1, y: 0), vertex: vertex, point2: point2)
        let flip = ((angle2 - angle1).isMinor || (angle2 - angle1).isStraight) != minor
        self.init(
            center: vertex,
            radius: radius,
            startAngle: flip ? angle2 : angle1,
            endAngle: flip ? angle1 : angle2,
            fullArcWhenZeroCentralAngle: fullArcWhenZeroCentralAngle
        )
    }
    
    // MARK: - Functions
    
    /// Rotates the arc counter-clockwise around its center by a certain angle
    /// - Parameters:
    ///   - angle: The angle to rotate by
    public mutating func rotate(by angle: SMAngle) {
        self.startAngle += angle
        self.endAngle += angle
    }
    
    /// Extend or contract the arc's length by a certain amount. Adjusts the arc's end.
    /// If the length is negative and has a magnitude greater than the arc's original length, the arc begins extending in the opposite direction.
    /// - Parameters:
    ///   - length: The length to extend (+) or contract (-) by
    public mutating func adjustLength(by length: Double) {
        if (self.length + length).isLessThanZero() {
            if abs(length).isGreater(than: self.circumference) {
                // WARNING: Recursion is used here
                self.adjustLength(by: length.truncatingRemainder(dividingBy: self.circumference))
            } else {
                let length = self.circumference + (self.length + length).truncatingRemainder(dividingBy: self.circumference)
                let rotation = self.startAngle
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
    public mutating func setLength(to length: Double) {
        let length = length.truncatingRemainder(dividingBy: self.circumference)
        guard !length.isZero() else {
            self.endAngle = self.startAngle
            return
        }
        let rotation = self.startAngle
        self.rotate(by: rotation * -1)
        if length.isLessThanZero() {
            self.endAngle = SMAngle(radians: abs(length)/self.radius)
            self.rotate(by: self.centralAngle * -1)
        } else {
            self.endAngle = SMAngle(radians: length/self.radius)
        }
        self.rotate(by: rotation)
    }
    
    /// Gets the point at a given proportional length of the arc. Measures from the start angle towards the end angle (counter clockwise).
    /// A proportion of 0.5 would return the mid point.
    /// A proportion of 1.0 would return the end point.
    /// - Parameters:
    ///   - proportion: The proportion of the arc's length from the start point at which the returned point lies
    /// - Returns: The point at the proportional distance (relative to the arc's length) from the start point
    public func pointAtProportion(_ proportion: Double) -> SMPoint {
        let x = self.center.x + self.radius * cos((self.startAngle + self.centralAngle*proportion).radians)
        let y = self.center.y + self.radius * sin((self.startAngle + self.centralAngle*proportion).radians)
        return SMPoint(x: x, y: y)
    }
    
    // MARK: - Transformations
    
    public mutating func translate(by point: SMPoint) {
        self.center += point
    }
    
    public mutating func translateCenter(to point: SMPoint) {
        self.center = point
    }
    
    public mutating func rotate(around center: SMPoint, by angle: SMAngle) {
        self.center.rotate(around: center, by: angle)
    }
    
    public mutating func scale(from point: SMPoint, scale: Double) {
        self.translate(by: point * -1)
        self.center *= scale
        self.radius *= scale
        self.translate(by: point)
    }
    
    // MARK: - Operations
    
    public static func + (left: SMArc, right: SMPoint) -> SMArc {
        return SMArc(
            center: left.center + right,
            radius: left.radius,
            startAngle: left._startAngle,
            endAngle: left._endAngle,
            fullArcWhenZeroCentralAngle: left.fullArcWhenZeroCentralAngle
        )
    }

    public static func += (left: inout SMArc, right: SMPoint) {
        left = left + right
    }

    public static func - (left: SMArc, right: SMPoint) -> SMArc {
        return SMArc(
            center: left.center - right,
            radius: left.radius,
            startAngle: left._startAngle,
            endAngle: left._endAngle,
            fullArcWhenZeroCentralAngle: left.fullArcWhenZeroCentralAngle
        )
    }

    public static func -= (left: inout SMArc, right: SMPoint) {
        left = left - right
    }
    
    public static func == (lhs: SMArc, rhs: SMArc) -> Bool {
        return (
            lhs.center == rhs.center
            && lhs.radius.isEqual(to: rhs.radius)
            && lhs.startAngle.isEquivalent(to: rhs.startAngle)
            && lhs.endAngle.isEquivalent(to: rhs.endAngle)
            && lhs.isFullCircle == rhs.isFullCircle
        )
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
