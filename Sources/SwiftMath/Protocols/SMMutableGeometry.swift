//
//  SMMutableGeometry.swift
//
//
//  Created by Andre Pham on 24/1/2024.
//

import Foundation

public protocol SMMutableGeometry: SMGeometry {
    
    /// This geometry's vertices (ordered)
    var vertices: [SMPoint] { get set }
    
}
extension SMMutableGeometry {
    
    public mutating func reverse() {
        self.vertices = self.vertices.reversed()
    }
    
    public mutating func add(_ point: SMPoint) {
        self.vertices.append(point)
    }
    
    public mutating func insert(_ point: SMPoint, at: Int) {
        self.vertices.insert(point, at: at)
    }
    
    public mutating func remove(at index: Int) -> SMPoint? {
        guard index < self.vertices.endIndex else {
            return nil
        }
        return self.vertices.remove(at: index)
    }
    
    public mutating func removeRedundantPoints() {
        guard self.vertices.count >= 3 else {
            self.removeDuplicatePoints()
            return
        }
        var pointIndicesToRemove = [Int]()
        for index in 0..<self.vertices.count - 2 {
            let point1 = self.vertices[index]
            let point2 = self.vertices[index + 1]
            let point3 = self.vertices[index + 2]
            let length1 = point1.length(to: point2) + point2.length(to: point3)
            let length2 = point1.length(to: point3)
            if length1.isEqual(to: length2) {
                pointIndicesToRemove.append(index + 1)
            }
        }
        guard !pointIndicesToRemove.isEmpty else {
            return
        }
        var newVertices = [SMPoint]()
        for (index, vertex) in self.vertices.enumerated() {
            if !pointIndicesToRemove.contains(index) {
                newVertices.append(vertex)
            }
        }
        self.vertices = newVertices
    }
    
    public mutating func removeDuplicatePoints() {
        guard self.vertices.count > 1 else {
            return
        }
        var pointIndicesToRemove = [Int]()
        for index in 0..<self.vertices.count - 1 {
            let point1 = self.vertices[index]
            let point2 = self.vertices[index + 1]
            if point1 == point2 {
                pointIndicesToRemove.append(index)
            }
        }
        guard !pointIndicesToRemove.isEmpty else {
            return
        }
        var newVertices = [SMPoint]()
        for (index, vertex) in self.vertices.enumerated() {
            if !pointIndicesToRemove.contains(index) {
                newVertices.append(vertex)
            }
        }
        self.vertices = newVertices
    }
    
    public mutating func translate(by point: SMPoint) {
        for index in self.vertices.indices {
            self.vertices[index] += point
        }
    }
    
    public mutating func translateCenter(to point: SMPoint) {
        guard let center = self.boundingBox?.center else {
            return
        }
        self.translate(by: point - center)
    }
    
    public mutating func rotate(around center: SMPoint, by angle: SMAngle) {
        for index in self.vertices.indices {
            self.vertices[index].rotate(around: center, by: angle)
        }
    }
    
    public mutating func scale(from point: SMPoint, scale: Double) {
        self.translate(by: point * -1)
        for index in self.vertices.indices {
            self.vertices[index] *= scale
        }
        self.translate(by: point)
    }
    
}
