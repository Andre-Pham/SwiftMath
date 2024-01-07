//
//  SMArc.swift
//
//
//  Created by Andre Pham on 7/1/2024.
//

import Foundation

/// Represents a segment of a circle's perimeter, defined by two points on the circumference and the path between them along the circle.
public class SMArc: SMClonable {
    
    public var center: SMPoint
    public var radius: Double
    public var startAngle: SMAngle
    public var endAngle: SMAngle
    public var length: Double {
        let angleDifference = self.endAngle - self.startAngle
        return self.radius*angleDifference.radians
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
    public var chord: SMLine {
        return SMLine(origin: self.startPoint, end: self.endPoint)
    }
    public var centralAngle: SMAngle {
        return (self.endAngle - self.startAngle).normalized
    }
    
    public init(center: SMPoint = SMPoint(), radius: Double, startAngle: SMAngle, endAngle: SMAngle) {
        self.center = center
        self.radius = radius
        self.startAngle = startAngle
        self.endAngle = endAngle
    }
    
    public required init(_ original: SMArc) {
        self.center = original.center.clone()
        self.radius = original.radius
        self.startAngle = original.startAngle.clone()
        self.endAngle = original.endAngle.clone()
    }
    
    // MARK: - Functions
    
    /// Rotates the arc counter-clockwise around its center by a certain angle
    /// - Parameters:
    ///   - angle: The angle to rotate by
    public func rotate(by angle: SMAngle) {
        self.startAngle += angle
        self.endAngle += angle
    }
    
}
