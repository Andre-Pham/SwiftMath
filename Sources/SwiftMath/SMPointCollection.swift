//
//  SMPointCollection.swift
//  
//
//  Created by Andre Pham on 7/1/2024.
//

import Foundation

/// Represents a collection of unordered points.
public struct SMPointCollection {
    
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
        return SMRect(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
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
    
    public init(points: SMPoint...) {
        self.init(points: points)
    }
    
    // MARK: - Functions
    
    public mutating func add(_ point: SMPoint) {
        self.points.append(point)
    }
    
    public mutating func remove(at index: Int) -> SMPoint? {
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
    
    public func duplicatedPoints() -> [SMPoint: Int] {
        var seenPoints = Set<SMPoint>()
        var duplicatedPoints = [SMPoint: Int]()
        for point in self.points {
            if seenPoints.contains(point) {
                if duplicatedPoints[point] != nil {
                    duplicatedPoints[point]! += 1
                } else {
                    duplicatedPoints[point] = 1
                }
            } else {
                seenPoints.insert(point)
            }
        }
        return duplicatedPoints
    }
    
    public func countDuplicatedPoints() -> Int {
        let uniquePoints = Set<SMPoint>(self.points)
        return self.points.count - uniquePoints.count
    }
    
    public func sortedByDistance(to otherPoint: SMPoint) -> [SMPoint] {
        return self.points.sorted { $0.length(to: otherPoint) < $1.length(to: otherPoint) }
    }
    
    public func toString(decimalPlaces: Int = 2) -> String {
        return "[\(self.points.map({ $0.toString(decimalPlaces: decimalPlaces) }).joined(separator: ", "))]"
    }
    
}

