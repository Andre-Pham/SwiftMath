//
//  SMHexagon.swift
//  
//
//  Created by Andre Pham on 3/3/2024.
//

import Foundation
import CoreGraphics

open class SMHexagon: SMGeometry, SMClonable, Equatable {
    
    // MARK: - Properties
    
    public var flatTop: Bool
    public var center: SMPoint
    public var sideLength: Double
    /// The maximum radius, from center to vertex
    public var circumradius: Double {
        return self.sideLength
    }
    /// The minimum radius, the perpendicular path from an edge midpoint to the center
    public var inradius: Double {
        return 0.86603*self.sideLength
    }
    /// The hexagon height
    public var height: Double {
        return self.flatTop ? 2.0*self.inradius : 2.0*self.sideLength
    }
    /// The hexagon width
    public var width: Double {
        return self.flatTop ? 2.0*self.sideLength : 2.0*self.inradius
    }
    /// The hexagon's polygon representation (starting with top right edge, going counter-clockwise)
    public var polygon: SMPolygon {
        return SMPolygon(vertices: self.vertices)
    }
    /// The hexagon's vertices going counter-clockwise, starting with right-most for flat tops, and top right for pointed tops
    public var vertices: [SMPoint] {
        var vertices = [SMPoint]()
        let startAngle: Double = self.flatTop ? 0.0 : .pi / 6 // Start at 0 for flat top, π/6 for pointy top
        let angleIncrement: Double = .pi / 3 // 60 degrees
        for i in 0..<6 {
            let angle = startAngle + angleIncrement * Double(i)
            let x = self.center.x + self.circumradius * cos(angle)
            let y = self.center.y + self.circumradius * sin(angle)
            vertices.append(SMPoint(x: x, y: y))
        }
        return vertices
    }
    /// Edges of the hexagon, STARTING WITH TOP-RIGHT EDGE, going counter-clockwise
    public var edges: [SMLineSegment] {
        return self.polygon.edges
    }
    /// The hexagon's bounding box
    public var boundingBox: SMRect {
        return SMRect(center: self.center, width: self.width, height: self.height)
    }
    
    // MARK: - Constructors
    
    public init(flatTop: Bool = false, center: SMPoint = SMPoint(), sideLength: Double) {
        self.flatTop = flatTop
        self.center = center
        self.sideLength = sideLength
    }
    
    public required init(_ original: SMHexagon) {
        self.flatTop = original.flatTop
        self.center = original.center.clone()
        self.sideLength = original.sideLength
    }
    
    // MARK: - Functions
    
    public func setWidth(to width: Double) {
        guard SM.isGreaterZero(width) else {
            self.sideLength = 0.0
            return
        }
        if self.flatTop {
            self.sideLength = width/(2.0*0.86603)
        } else {
            self.sideLength = width/2.0
        }
    }
    
    public func widen(by length: Double) {
        self.setWidth(to: length + self.width)
    }
    
    public func setHeight(to height: Double) {
        guard SM.isGreaterZero(height) else {
            self.sideLength = 0.0
            return
        }
        if self.flatTop {
            self.sideLength = width/2.0
        } else {
            self.sideLength = width/(2.0*0.86603)
        }
    }
    
    public func heighten(by height: Double) {
        self.setHeight(to: height + self.height)
    }
    
    // MARK: - Transformations
    
    public func translate(by point: SMPoint) {
        self.center += point
    }
    
    /// Rotates the center of this hexagon around a point
    public func rotate(around center: SMPoint, by angle: SMAngle) {
        self.center.rotate(around: center, by: angle)
    }
    
    public func scale(from point: SMPoint, by factor: Double) {
        self.translate(by: point * -1)
        self.center *= factor
        self.sideLength *= factor
        self.translate(by: point)
    }
    
    // MARK: - Operations
    
    public static func == (lhs: SMHexagon, rhs: SMHexagon) -> Bool {
        return lhs.flatTop == rhs.flatTop && lhs.center == rhs.center && SM.isEqual(lhs.sideLength, rhs.sideLength)
    }
    
    // MARK: - Core Graphics
    
    public var cgPath: CGPath {
        return self.polygon.cgPath
    }
    
}
