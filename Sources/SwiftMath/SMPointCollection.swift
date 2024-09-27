//
//  SMPointCollection.swift
//  
//
//  Created by Andre Pham on 7/1/2024.
//

import Foundation

open class SMPointCollection: SMClonable {
    
    public var points = [SMPoint]()
    public var minXPoint: SMPoint? {
        return self.points.min(by: { $0.x < $1.x })
    }
    public var minYPoint: SMPoint? {
        return self.points.min(by: { $0.y < $1.y })
    }
    public var maxXPoint: SMPoint? {
        return self.points.max(by: { $0.x < $1.x })
    }
    public var maxYPoint: SMPoint? {
        return self.points.max(by: { $0.y < $1.y })
    }
    public var minX: Double? {
        return self.minXPoint?.x
    }
    public var maxX: Double? {
        return self.maxXPoint?.x
    }
    public var minY: Double? {
        return self.minYPoint?.y
    }
    public var maxY: Double? {
        return self.maxYPoint?.y
    }
    public var boundingBox: SMRect? {
        let vertices = self.points
        guard !vertices.isEmpty else {
            return nil
        }
        var minX = vertices.first!.x
        var maxX = vertices.first!.x
        var minY = vertices.first!.y
        var maxY = vertices.first!.y
        for vertex in vertices.dropFirst() {
            minX = min(vertex.x, minX)
            maxX = max(vertex.x, maxX)
            minY = min(vertex.y, minY)
            maxY = max(vertex.y, maxY)
        }
        return SMRect(
            origin: SMPoint(x: minX, y: minY),
            end: SMPoint(x: maxX, y: maxY)
        )
    }
    public var averagePoint: SMPoint? {
        guard !self.points.isEmpty else {
            return nil
        }
        return SMPoint(
            x: self.points.map({ $0.x }).reduce(0.0, +)/Double(self.points.count),
            y: self.points.map({ $0.y }).reduce(0.0, +)/Double(self.points.count)
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
    
    public func add(_ point: SMPoint) {
        self.points.append(point.clone())
    }
    
    public func remove(at index: Int) -> SMPoint? {
        guard index < self.points.endIndex else {
            return nil
        }
        return self.points.remove(at: index)
    }
    
    public func containsPoint(_ otherPoint: SMPoint) -> Bool {
        return self.points.contains(otherPoint)
    }
    
    public func closestPoint(to otherPoint: SMPoint) -> SMPoint? {
        guard !self.points.isEmpty else {
            return nil
        }
        if self.points.count == 1 {
            return self.points.first
        }
        return self.points.min { $0.length(to: otherPoint) < $1.length(to: otherPoint) }
    }
    
    public func furthestPoint(to otherPoint: SMPoint) -> SMPoint? {
        guard !self.points.isEmpty else {
            return nil
        }
        if self.points.count == 1 {
            return self.points.first
        }
        return self.points.max { $0.length(to: otherPoint) < $1.length(to: otherPoint) }
    }
    
    public func sortedByDistance(to otherPoint: SMPoint) -> [SMPoint] {
        return self.points.sorted { $0.length(to: otherPoint) < $1.length(to: otherPoint) }
    }
    
}

