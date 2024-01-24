//
//  SMMutatableGeometry.swift
//
//
//  Created by Andre Pham on 24/1/2024.
//

import Foundation

public protocol SMMutatableGeometry: AnyObject, SMGeometry {
    
    /// This geometry's vertices (ordered)
    var vertices: [SMPoint] { get set }
    
}
extension SMMutatableGeometry {
    
    public func add(_ point: SMPoint) {
        self.vertices.append(point.clone())
    }
    
    public func remove(at index: Int) -> SMPoint? {
        guard index < self.vertices.endIndex else {
            return nil
        }
        return self.vertices.remove(at: index)
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
    
}
