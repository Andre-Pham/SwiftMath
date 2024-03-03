//
//  SMMutableGeometry.swift
//
//
//  Created by Andre Pham on 24/1/2024.
//

import Foundation

public protocol SMMutableGeometry: AnyObject, SMGeometry {
    
    /// This geometry's vertices (ordered)
    var vertices: [SMPoint] { get set }
    
}
extension SMMutableGeometry {
    
    public func reverse() {
        self.vertices = self.vertices.reversed()
    }
    
    public func add(_ point: SMPoint) {
        self.vertices.append(point.clone())
    }
    
    public func insert(_ point: SMPoint, at: Int) {
        self.vertices.insert(point.clone(), at: at)
    }
    
    public func remove(at index: Int) -> SMPoint? {
        guard index < self.vertices.endIndex else {
            return nil
        }
        return self.vertices.remove(at: index)
    }
    
    public func removeRedundantPoints() {
        guard self.vertices.count >= 3 else {
            return
        }
        var pointIndicesToRemove = [Int]()
        for index in 0..<self.vertices.count - 2 {
            let point1 = self.vertices[index]
            let point2 = self.vertices[index + 1]
            let point3 = self.vertices[index + 2]
            let length1 = point1.length(to: point2) + point2.length(to: point3)
            let length2 = point1.length(to: point3)
            if SM.isEqual(length1, length2) {
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
    
    public func translate(by point: SMPoint) {
        for index in self.vertices.indices {
            self.vertices[index] += point
        }
    }
    
    public func rotate(around center: SMPoint, by angle: SMAngle) {
        for index in self.vertices.indices {
            self.vertices[index].rotate(around: center, by: angle)
        }
    }
    
    public func scale(from point: SMPoint, by factor: Double) {
        self.translate(by: point * -1)
        for index in self.vertices.indices {
            self.vertices[index] *= factor
        }
        self.translate(by: point)
    }
    
}
