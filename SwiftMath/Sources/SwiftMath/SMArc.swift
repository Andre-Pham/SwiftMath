//
//  SMArc.swift
//
//
//  Created by Andre Pham on 7/1/2024.
//

import Foundation

/// Represents a segment of a circle's perimeter, defined by two points on the circumference and the path between them along the circle.
open class SMArc: SMClonable {
    
    public var center: SMPoint
    public var radius: Double
    private var _startAngle: SMAngle
    public var startAngle: SMAngle {
        get { return self._startAngle.normalized }
        set { self._startAngle = newValue }
    }
    private var _endAngle: SMAngle
    public var endAngle: SMAngle {
        get { return self._endAngle.normalized }
        set { self._endAngle = newValue }
    }
    public var length: Double {
        let reference = self.clone()
        reference.rotate(by: reference.startAngle * -1)
        let angleDifference = reference.endAngle - reference.startAngle
        return reference.radius*angleDifference.radians
    }
    public var circumference: Double {
        return 2.0 * .pi * self.radius
    }
    public var startPoint: SMPoint {
        let x = self.center.x + self.radius * cos(self.startAngle.radians)
        let y = self.center.y + self.radius * sin(self.startAngle.radians)
        return SMPoint(x: x, y: y)
    }
    public var endPoint: SMPoint {
        let x = self.center.x + self.radius * cos(self.endAngle.radians)
        let y = self.center.y + self.radius * sin(self.endAngle.radians)
        return SMPoint(x: x, y: y)
    }
    /// The straight line between the start point and end point of the arc
    public var chord: SMLineSegment {
        return SMLineSegment(origin: self.startPoint, end: self.endPoint)
    }
    public var centralAngle: SMAngle {
        let reference = self.clone()
        reference.rotate(by: reference.startAngle * -1)
        return (reference.endAngle - reference.startAngle).normalized
    }
    
    public init(center: SMPoint = SMPoint(), radius: Double, startAngle: SMAngle, endAngle: SMAngle) {
        self.center = center
        self.radius = radius
        self._startAngle = startAngle
        self._endAngle = endAngle
    }
    
    public required init(_ original: SMArc) {
        self.center = original.center.clone()
        self.radius = original.radius
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
    
}
