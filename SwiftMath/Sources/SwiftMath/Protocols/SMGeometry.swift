//
//  File.swift
//  
//
//  Created by Andre Pham on 22/1/2024.
//

import Foundation

public protocol SMGeometry {
    
    /// This geometry's vertices (ordered)
    var vertices: [SMPoint] { get }
    /// This geometry's edges (ordered)
    var edges: [SMLineSegment] { get }
    
    func translate(by point: SMPoint)
    func rotate(around center: SMPoint, by angle: SMAngle)
    
}
extension SMGeometry {
    
    public var minXPoint: SMPoint {
        return self.vertices.min(by: { $0.x < $1.x }) ?? SMPoint()
    }
    public var minYPoint: SMPoint {
        return self.vertices.min(by: { $0.y < $1.y }) ?? SMPoint()
    }
    public var maxXPoint: SMPoint {
        return self.vertices.max(by: { $0.x < $1.x }) ?? SMPoint()
    }
    public var maxYPoint: SMPoint {
        return self.vertices.max(by: { $0.y < $1.y }) ?? SMPoint()
    }
    public var minX: Double {
        return self.minXPoint.x
    }
    public var maxX: Double {
        return self.maxXPoint.x
    }
    public var minY: Double {
        return self.minYPoint.y
    }
    public var maxY: Double {
        return self.maxYPoint.y
    }
    public var boundingBox: SMRect {
        return SMRect(
            origin: SMPoint(x: self.minX, y: self.minY),
            end: SMPoint(x: self.maxX, y: self.maxY)
        )
    }
    
    public func intersects(point: SMPoint) -> Bool {
        for edge in self.edges {
            if edge.intersects(point: point) {
                return true
            }
        }
        return false
    }
    
    public func intersects(geometry: SMGeometry) -> Bool {
        guard self.boundingBox.intersects(with: geometry.boundingBox) else {
            return false
        }
        for edge in self.edges {
            for otherEdge in geometry.edges {
                if edge.intersects(line: otherEdge) {
                    return true
                }
            }
        }
        return false
    }
    
}
