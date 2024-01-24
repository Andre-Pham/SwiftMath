//
//  SMPolyline.swift
//  
//
//  Created by Andre Pham on 19/1/2024.
//

import Foundation

public class SMPolyline: SMMutatableGeometry, SMClonable {
    
    /// This geometry's vertices (ordered)
    public var vertices = [SMPoint]()
    /// This geometry's edges (ordered)
    public var edges: [SMLineSegment] {
        guard self.vertices.count > 1 else {
            return []
        }
        var result = [SMLineSegment]()
        for index in self.vertices.indices.dropLast() {
            result.append(SMLineSegment(origin: self.vertices[index], end: self.vertices[index + 1]))
        }
        return result
    }
    public var isValid: Bool {
        return SM.isGreaterZero(self.length)
    }
    public var length: Double {
        guard self.vertices.count > 1 else {
            return 0.0
        }
        var totalLength = 0.0
        for index in self.vertices.indices.dropLast() {
            totalLength += self.vertices[index].length(to: self.vertices[index + 1])
        }
        return totalLength
    }
    public var closed: SMPolygon {
        return SMPolygon(vertices: self.vertices.clone())
    }
    
    // MARK: - Constructors
    
    public init(vertices: [SMPoint]) {
        self.vertices = vertices
    }
    
    public convenience init(vertices: SMPoint...) {
        self.init(vertices: vertices)
    }
    
    public required init(_ original: SMPolyline) {
        self.vertices = original.vertices.clone()
    }
    
    // MARK: - Functions
    
}
