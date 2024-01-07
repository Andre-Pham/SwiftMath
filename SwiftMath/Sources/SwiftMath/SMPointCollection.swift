//
//  SMPointCollection.swift
//  
//
//  Created by Andre Pham on 7/1/2024.
//

import Foundation

class SMPointCollection {
    
    private(set) var points = [SMPoint]()
    public var minXPoint: SMPoint {
        return self.points.min(by: { $0.x < $1.x }) ?? SMPoint()
    }
    public var minYPoint: SMPoint {
        return self.points.min(by: { $0.y < $1.y }) ?? SMPoint()
    }
    public var maxXPoint: SMPoint {
        return self.points.max(by: { $0.x < $1.x }) ?? SMPoint()
    }
    public var maxYPoint: SMPoint {
        return self.points.max(by: { $0.y < $1.y }) ?? SMPoint()
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
    
    // MARK: - Constructors
    
    public init(points: [SMPoint]) {
        self.points = points
    }
    
    public convenience init(points: SMPoint...) {
        self.init(points: points)
    }
    
    public required init(_ original: SMPointCollection) {
        self.points = original.points.clone()
    }
    
    // MARK: - Functions
    
}

