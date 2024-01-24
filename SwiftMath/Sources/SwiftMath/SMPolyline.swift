//
//  SMPolyline.swift
//  
//
//  Created by Andre Pham on 19/1/2024.
//

import Foundation

public class SMPolyline: SMClonable {
    
    private(set) var orderedPoints = [SMPoint]()
    public var lineSegments: [SMLineSegment] {
        guard self.orderedPoints.count > 1 else {
            return []
        }
        var result = [SMLineSegment]()
        for index in self.orderedPoints.indices.dropLast() {
            result.append(SMLineSegment(origin: self.orderedPoints[index], end: self.orderedPoints[index + 1]))
        }
        return result
    }
    public var isValid: Bool {
        return SM.isGreaterZero(self.length)
    }
    public var length: Double {
        guard self.orderedPoints.count > 1 else {
            return 0.0
        }
        var totalLength = 0.0
        for index in self.orderedPoints.indices.dropLast() {
            totalLength += self.orderedPoints[index].length(to: self.orderedPoints[index + 1])
        }
        return totalLength
    }
    public var pointCollection: SMPointCollection {
        return SMPointCollection(points: self.orderedPoints)
    }
    public var closed: SMPolygon {
        return SMPolygon(orderedPoints: self.orderedPoints.clone())
    }
    
    // MARK: - Constructors
    
    public init(orderedPoints: [SMPoint]) {
        self.orderedPoints = orderedPoints
    }
    
    public convenience init(orderedPoints: SMPoint...) {
        self.init(orderedPoints: orderedPoints)
    }
    
    public required init(_ original: SMPolyline) {
        self.orderedPoints = original.orderedPoints.clone()
    }
    
    // MARK: - Functions
    
    public func add(_ point: SMPoint) {
        self.orderedPoints.append(point.clone())
    }
    
    public func remove(at index: Int) -> SMPoint? {
        guard index < self.orderedPoints.endIndex else {
            return nil
        }
        return self.orderedPoints.remove(at: index)
    }
    
    public func intersects(point: SMPoint) -> Bool {
        for segment in self.lineSegments {
            if segment.intersects(point: point) {
                return true
            }
        }
        return false
    }
    
    // MARK: - Transformations
    
    public func translate(by point: SMPoint) {
        for index in self.orderedPoints.indices {
            self.orderedPoints[index] += point
        }
    }
    
    public func rotate(around center: SMPoint, by angle: SMAngle) {
        for index in self.orderedPoints.indices {
            self.orderedPoints[index].rotate(around: center, by: angle)
        }
    }
    
}
