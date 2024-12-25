//
//  SMCurvilinearEdges.swift
//
//
//  Created by Andre Pham on 29/2/2024.
//

import Foundation
import CoreGraphics

/// Represents curvilinear edges.
/// A sequence of ordered (but not necessarily connected) straight or curved edges.
public struct SMCurvilinearEdges: SMTransformable {
    
    // MARK: - Properties
    
    private var linearEdges = [Int: SMLineSegment]()
    private var bezierEdges = [Int: SMBezierCurve]()
    private var quadEdges = [Int: SMQuadCurve]()
    private var arcEdges = [Int: SMArc]()
    public private(set) var edgeCount = 0
    public var lastPoint: SMPoint? {
        guard self.edgeCount > 0 else {
            return nil
        }
        if let last = self.linearEdges[self.edgeCount - 1] {
            return last.end
        } else if let last = self.bezierEdges[self.edgeCount - 1] {
            return last.end
        } else if let last = self.quadEdges[self.edgeCount - 1] {
            return last.end
        } else if let last = self.arcEdges[self.edgeCount - 1] {
            return last.endPoint
        }
        return nil
    }
    public var assortedLinearEdges: [SMLineSegment] {
        return Array(self.linearEdges.values)
    }
    public var assortedBezierEdges: [SMBezierCurve] {
        return Array(self.bezierEdges.values)
    }
    public var assortedQuadEdges: [SMQuadCurve] {
        return Array(self.quadEdges.values)
    }
    public var assortedArcEdges: [SMArc] {
        return Array(self.arcEdges.values)
    }
    public var sortedLinearEdges: [SMLineSegment] {
        return self.linearEdges.keys.sorted().compactMap({ self.linearEdges[$0] })
    }
    public var sortedBezierEdges: [SMBezierCurve] {
        return self.bezierEdges.keys.sorted().compactMap({ self.bezierEdges[$0] })
    }
    public var sortedQuadEdges: [SMQuadCurve] {
        return self.quadEdges.keys.sorted().compactMap({ self.quadEdges[$0] })
    }
    public var sortedArcEdges: [SMArc] {
        return self.arcEdges.keys.sorted().compactMap({ self.arcEdges[$0] })
    }
    /// The bounding box that contains all curves and edges
    public var boundingBox: SMRect? {
        if self.edgeCount == 0 {
            return nil
        }
        return SMRect(self.cgPath.boundingBoxOfPath)
    }
    
    // MARK: - Constructors
    
    public init() { }
    
    // MARK: - Functions
    
    public mutating func addLinearEdge(_ edge: SMLineSegment) {
        self.linearEdges[self.edgeCount] = edge
        self.edgeCount += 1
    }
    
    public mutating func addBezierEdge(_ edge: SMBezierCurve) {
        self.bezierEdges[self.edgeCount] = edge
        self.edgeCount += 1
    }
    
    public mutating func addQuadEdge(_ edge: SMQuadCurve) {
        self.quadEdges[self.edgeCount] = edge
        self.edgeCount += 1
    }
    
    public mutating func addArcEdge(_ edge: SMArc) {
        self.arcEdges[self.edgeCount] = edge
        self.edgeCount += 1
    }
    
    public mutating func removeEdge(at index: Int) {
        let linearRemoved = self.linearEdges.removeValue(forKey: index) != nil
        let bezierRemoved = self.bezierEdges.removeValue(forKey: index) != nil
        let quadRemoved = self.quadEdges.removeValue(forKey: index) != nil
        let arcRemoved = self.arcEdges.removeValue(forKey: index) != nil
        let edgeWasRemoved = linearRemoved || bezierRemoved || quadRemoved || arcRemoved
        guard edgeWasRemoved else {
            return
        }
        self.edgeCount -= 1
        for (key, value) in self.linearEdges {
            if key > index {
                self.linearEdges[key - 1] = value
                self.linearEdges[key] = nil
            }
        }
        for (key, value) in self.bezierEdges {
            if key > index {
                self.bezierEdges[key - 1] = value
                self.bezierEdges[key] = nil
            }
        }
        for (key, value) in self.quadEdges {
            if key > index {
                self.quadEdges[key - 1] = value
                self.quadEdges[key] = nil
            }
        }
        for (key, value) in self.arcEdges {
            if key > index {
                self.arcEdges[key - 1] = value
                self.arcEdges[key] = nil
            }
        }
    }
    
    public mutating func removeRedundantEdges() {
        for edgeIndex in (0..<self.edgeCount).reversed() {
            if let linearEdge = self.linearEdges[edgeIndex] {
                if linearEdge.length.isZero() {
                    self.removeEdge(at: edgeIndex)
                } else if let nextLinearEdge = self.linearEdges[edgeIndex + 1], linearEdge.end == nextLinearEdge.origin {
                    let point1 = linearEdge.origin
                    let point2 = linearEdge.end
                    let point3 = nextLinearEdge.end
                    let length1 = point1.length(to: point2) + point2.length(to: point3)
                    let length2 = point1.length(to: point3)
                    if length1.isEqual(to: length2) {
                        var extendedLinearEdge = linearEdge
                        extendedLinearEdge.adjustLength(by: nextLinearEdge.length)
                        self.linearEdges[edgeIndex] = extendedLinearEdge
                        self.removeEdge(at: edgeIndex + 1)
                    }
                }
            } else if let bezierEdge = self.bezierEdges[edgeIndex] {
                if bezierEdge.lengthIsZero {
                    self.removeEdge(at: edgeIndex)
                }
            } else if let quadEdge = self.quadEdges[edgeIndex] {
                if quadEdge.lengthIsZero {
                    self.removeEdge(at: edgeIndex)
                }
            } else if let arcEdge = self.arcEdges[edgeIndex] {
                if arcEdge.length.isZero() {
                    self.removeEdge(at: edgeIndex)
                }
            } else {
                assertionFailure("Logic error - shouldn't be reachable")
            }
        }
    }
    
    // MARK: - Transformations
    
    public mutating func translate(by point: SMPoint) {
        for (key, linearEdge) in self.linearEdges {
            self.linearEdges[key] = linearEdge + point
        }
        for (key, bezierEdge) in self.bezierEdges {
            self.bezierEdges[key] = bezierEdge + point
        }
        for (key, quadEdge) in self.quadEdges {
            self.quadEdges[key] = quadEdge + point
        }
        for (key, arcEdge) in self.arcEdges {
            self.arcEdges[key] = arcEdge + point
        }
    }
    
    public mutating func translateCenter(to point: SMPoint) {
        guard let center = self.boundingBox?.center else {
            return
        }
        self.translate(by: point - center)
    }
    
    public mutating func rotate(around center: SMPoint, by angle: SMAngle) {
        for (key, var linearEdge) in self.linearEdges {
            linearEdge.rotate(around: center, by: angle)
            self.linearEdges[key] = linearEdge
        }
        for (key, var bezierEdge) in self.bezierEdges {
            bezierEdge.rotate(around: center, by: angle)
            self.bezierEdges[key] = bezierEdge
        }
        for (key, var quadEdge) in self.quadEdges {
            quadEdge.rotate(around: center, by: angle)
            self.quadEdges[key] = quadEdge
        }
        for (key, var arcEdge) in self.arcEdges {
            arcEdge.rotate(around: center, by: angle)
            self.arcEdges[key] = arcEdge
        }
    }
    
    public mutating func scale(from point: SMPoint, scale: Double) {
        for (key, var linearEdge) in self.linearEdges {
            linearEdge.scale(from: point, scale: scale)
            self.linearEdges[key] = linearEdge
        }
        for (key, var bezierEdge) in self.bezierEdges {
            bezierEdge.scale(from: point, scale: scale)
            self.bezierEdges[key] = bezierEdge
        }
        for (key, var quadEdge) in self.quadEdges {
            quadEdge.scale(from: point, scale: scale)
            self.quadEdges[key] = quadEdge
        }
        for (key, var arcEdge) in self.arcEdges {
            arcEdge.scale(from: point, scale: scale)
            self.arcEdges[key] = arcEdge
        }
    }
    
    // MARK: - Operations
    
    public static func + (left: SMCurvilinearEdges, right: SMPoint) -> SMCurvilinearEdges {
        var new = left
        new.translate(by: right)
        return new
    }

    public static func += (left: inout SMCurvilinearEdges, right: SMPoint) {
        left = left + right
    }

    public static func - (left: SMCurvilinearEdges, right: SMPoint) -> SMCurvilinearEdges {
        var new = left
        new.translate(by: right * -1)
        return new
    }

    public static func -= (left: inout SMCurvilinearEdges, right: SMPoint) {
        left = left - right
    }
    
    public static func == (lhs: SMCurvilinearEdges, rhs: SMCurvilinearEdges) -> Bool {
        guard lhs.linearEdges.count == rhs.linearEdges.count else {
            return false
        }
        guard lhs.bezierEdges.count == rhs.bezierEdges.count else {
            return false
        }
        guard lhs.quadEdges.count == rhs.quadEdges.count else {
            return false
        }
        guard lhs.arcEdges.count == rhs.arcEdges.count else {
            return false
        }
        assert(lhs.edgeCount == rhs.edgeCount, "Edge counter out of sync - logic error")
        return lhs.linearEdges == rhs.linearEdges && lhs.bezierEdges == rhs.bezierEdges && lhs.quadEdges == rhs.quadEdges && lhs.arcEdges == rhs.arcEdges
    }
    
    // MARK: - Core Graphics
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        for edgeIndex in 0..<self.edgeCount {
            if let arc = self.arcEdges[edgeIndex] {
                path.addPath(arc.cgPath)
            } else if let quad = self.quadEdges[edgeIndex] {
                path.addPath(quad.cgPath)
            } else if let bezier = self.bezierEdges[edgeIndex] {
                path.addPath(bezier.cgPath)
            } else if let linear = self.linearEdges[edgeIndex] {
                path.addPath(linear.cgPath)
            }
        }
        return path
    }
    
}
