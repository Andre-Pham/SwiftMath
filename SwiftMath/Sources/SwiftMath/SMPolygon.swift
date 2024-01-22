//
//  SMPolygon.swift
//
//
//  Created by Andre Pham on 19/1/2024.
//

import Foundation

public class SMPolygon: SMClonable {
    
    private(set) var orderedPoints = [SMPoint]()
    public var lineSegments: [SMLine] {
        guard self.orderedPoints.count > 1 else {
            return []
        }
        var result = [SMLine]()
        for index in self.orderedPoints.indices.dropLast() {
            result.append(SMLine(origin: self.orderedPoints[index], end: self.orderedPoints[index + 1]))
        }
        result.append(SMLine(origin: self.orderedPoints.last!, end: self.orderedPoints.first!))
        return result
    }
    public var isValid: Bool {
        // Must at least be a triangle
        guard self.orderedPoints.count > 2 else {
            return false
        }
        let lineSegments = self.lineSegments
        if !lineSegments.allSatisfy({ $0.isValid }) {
            // One or more line segments are invalid
            return false
        }
        for index1 in lineSegments.indices {
            for index2 in lineSegments.indices {
                guard index1 != index2 else {
                    continue
                }
                let linesAreAdjacent = abs(index1 - index2) == 1 || abs(index1 - index2) == (lineSegments.count - 1)
                let line1 = lineSegments[index1]
                let line2 = lineSegments[index2]
                if !linesAreAdjacent && line1.intersects(line: line2) {
                    // Lines are not adjacent yet they intersect
                    return false
                }
                if line1.overlaps(with: line2) {
                    // Lines overlap
                    return false
                }
            }
        }
        return true
    }
    public var area: Double? {
        guard self.isValid else {
            return nil
        }
        // Shoelace formula
        var sum = 0.0
        for i in self.orderedPoints.indices {
            let current = self.orderedPoints[i]
            let next = self.orderedPoints[(i + 1)%self.orderedPoints.count]
            sum += (current.x * next.y) - (next.x * current.y)
        }
        // Closing the loop: adding the product of the last and the first point
        let last = self.orderedPoints.last!
        let first = self.orderedPoints.first!
        sum += (last.x * first.y) - (first.x * last.y)
        return 0.5 * abs(sum)
    }
    public var perimeter: Double? {
        guard self.isValid else {
            return nil
        }
        var totalLength = self.orderedPoints.last!.length(to: self.orderedPoints.first!)
        for index in self.orderedPoints.indices.dropLast() {
            totalLength += self.orderedPoints[index].length(to: self.orderedPoints[index + 1])
        }
        return totalLength
    }
    public var pointCollection: SMPointCollection {
        return SMPointCollection(points: self.orderedPoints)
    }
    
    // MARK: - Constructors
    
    public init(orderedPoints: [SMPoint]) {
        self.orderedPoints = orderedPoints
    }
    
    public convenience init(orderedPoints: SMPoint...) {
        self.init(orderedPoints: orderedPoints)
    }
    
    public required init(_ original: SMPolygon) {
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
    
}
