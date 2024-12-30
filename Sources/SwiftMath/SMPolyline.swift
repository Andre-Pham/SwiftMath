//
//  SMPolyline.swift
//  
//
//  Created by Andre Pham on 19/1/2024.
//

import Foundation
import CoreGraphics

/// Represents a polyline.
/// A sequence of connected straight edges.
public struct SMPolyline: SMMutableGeometry {
    
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
    /// This geometry's triplets (ordered)
    public var triplets: [(origin: SMPoint, corner: SMPoint, end: SMPoint)] {
        guard self.edges.count > 1 else {
            return []
        }
        var result = [(origin: SMPoint, corner: SMPoint, end: SMPoint)]()
        for index in 0..<(self.vertices.count - 2) {
            result.append((origin: self.vertices[index], corner: self.vertices[index + 1], end: self.vertices[index + 2]))
        }
        return result
    }
    /// True if this polyline is valid (length is non-zero)
    public var isValid: Bool {
        return self.length.isGreaterThanZero()
    }
    /// The total length of all this polyline's edges
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
    /// This as a closed polygon
    public var closed: SMPolygon {
        return SMPolygon(vertices: self.vertices)
    }
    
    /// Returns this with every corner rounded.
    /// Replaces corner vertices with bezier curves.
    /// - Parameters:
    ///   - pointDistance: The target distance away from the corner vertex the bezier origin/end points are placed at (whilst remaining on the original edge)
    ///   - controlPointDistance: The target distance away from the control origin/end points (towards the original corner vertex) the bezier origin/end control points are placed at (whilst remaining on the original edge)
    /// - Returns: A collection of curvilinear edges (bezier and linear edges)
    public func roundedCorners(pointDistance: Double, controlPointDistance: Double) -> SMCurvilinearEdges {
        var result = SMCurvilinearEdges()
        var polyline = self
        polyline.removeDuplicatePoints()
        guard polyline.isValid else {
            return result
        }
        guard polyline.edges.count > 1 else {
            result.addLinearEdge(self.edges[0])
            return result
        }
        let triplets = self.triplets
        
        var tripletPointDistancesMap = [Int: Double]()
        let tripletMinEdgeLengths = triplets.map({ min($0.origin.length(to: $0.corner), $0.corner.length(to: $0.end)) })
        let tripletsWithIndices = triplets.enumerated().sorted(by: { t1, t2 in
            let triplet1MinEdgeLength = tripletMinEdgeLengths[t1.offset]
            let triplet2MinEdgeLength = tripletMinEdgeLengths[t2.offset]
            return triplet1MinEdgeLength < triplet2MinEdgeLength
        })
        for (tripletIndex, triplet) in tripletsWithIndices {
            let originToCornerLength = triplet.origin.length(to: triplet.corner)
            let cornerToEndLength = triplet.corner.length(to: triplet.end)
            let nextTripletPointDistance = tripletPointDistancesMap[tripletIndex + 1]
            let prevTripletPointDistance = tripletPointDistancesMap[tripletIndex - 1]
            let tripletIsStraight = triplet.origin.length(to: triplet.end).isEqual(to: originToCornerLength + cornerToEndLength)
            if tripletIsStraight {
                tripletPointDistancesMap[tripletIndex] = 0.0
            } else if let nextTripletPointDistance, let prevTripletPointDistance {
                let prevPotentialPointDistance = originToCornerLength - prevTripletPointDistance
                let nextPotentialPointDistance = cornerToEndLength - nextTripletPointDistance
                tripletPointDistancesMap[tripletIndex] = [prevPotentialPointDistance, nextPotentialPointDistance, pointDistance].min()!
            } else if let nextTripletPointDistance {
                let originToCornerIsFirst = tripletIndex == 0 && originToCornerLength.isLessOrEqual(to: cornerToEndLength)
                let prevPotentialPointDistance = originToCornerLength / (originToCornerIsFirst ? 1.0 : 2.0)
                let nextPotentialPointDistance = cornerToEndLength - nextTripletPointDistance
                tripletPointDistancesMap[tripletIndex] = [prevPotentialPointDistance, nextPotentialPointDistance, pointDistance].min()!
            } else if let prevTripletPointDistance {
                let cornerToEndIsLast = tripletIndex == triplets.count - 1 && cornerToEndLength.isLessOrEqual(to: originToCornerLength)
                let prevPotentialPointDistance = originToCornerLength - prevTripletPointDistance
                let nextPotentialPointDistance = cornerToEndLength / (cornerToEndIsLast ? 1.0 : 2.0)
                tripletPointDistancesMap[tripletIndex] = [prevPotentialPointDistance, nextPotentialPointDistance, pointDistance].min()!
            } else {
                let minEdgeLength = tripletMinEdgeLengths[tripletIndex]
                let minEdgeIsFirst = tripletIndex == 0 && originToCornerLength.isLessOrEqual(to: cornerToEndLength)
                let minEdgeIsLast = tripletIndex == triplets.count - 1 && cornerToEndLength.isLessOrEqual(to: originToCornerLength)
                let minEdgeIsFirstOrLast = minEdgeIsFirst || minEdgeIsLast
                tripletPointDistancesMap[tripletIndex] = min(pointDistance, minEdgeLength / (minEdgeIsFirstOrLast ? 1.0 : 2.0))
            }
        }
        
        let tripletPointDistances = tripletPointDistancesMap
            .sorted(by: { $0.key < $1.key })
            .map({ $0.value })
        assert(tripletPointDistances.count == triplets.count)
        
        for (index, triplet) in triplets.enumerated() {
            let originToCorner = SMLineSegment(origin: triplet.origin, end: triplet.corner)
            let cornerToEnd = SMLineSegment(origin: triplet.corner, end: triplet.end)
            let tripletIsStraight = originToCorner.origin.length(to: cornerToEnd.end).isEqual(to: originToCorner.length + cornerToEnd.length)
            
            // The applied point distance (max that can be done)
            // E.g. if the point distance is 50, but the first line has a length of 10
            let appliedPointDistance = tripletPointDistances[index]
            let previousAppliedPointDistance = index == 0 ? 0.0 : tripletPointDistances[index - 1]
            
            // The applied control point distance (max that can be done)
            // E.g. if it's greater than the point distance
            let maxControlPointDistance = appliedPointDistance
            let appliedControlPointDistance = min(controlPointDistance, maxControlPointDistance)
            
            // Straight edge
            var straightEdge = originToCorner
            let straightEdgeDirection = straightEdge.angle!
            straightEdge.adjustLength(by: -appliedPointDistance)
            
            // Next straight edge
            var nextStraightEdge = cornerToEnd
            let nextStraightEdgeDirection = nextStraightEdge.angle!
            nextStraightEdge.adjustLength(by: -appliedPointDistance, anchorEnd: true)
            
            // Curved edge origin and origin control point
            let origin = straightEdge.end
            let originControlEdge = SMLineSegment(
                origin: straightEdge.origin,
                angle: straightEdgeDirection,
                length: straightEdge.length + appliedControlPointDistance
            )
            let originControlPoint = originControlEdge.end
            
            // Curved edge end and end control point
            let end = nextStraightEdge.origin
            let endControlEdge = SMLineSegment(
                origin: nextStraightEdge.end,
                angle: nextStraightEdgeDirection + SMAngle(radians: Double.pi),
                length: nextStraightEdge.length + appliedControlPointDistance
            )
            let endControlPoint = endControlEdge.end
            
            // Add to result
            // Adjust straight edge here, otherwise if its length is zero, its length can't be adjusted above (0 length has no direction)
            straightEdge.adjustLength(by: -previousAppliedPointDistance, anchorEnd: true)
            if straightEdge.length.isGreaterThanZero() {
                result.addLinearEdge(straightEdge)
            }
            if !tripletIsStraight {
                result.addBezierEdge(SMBezierCurve(
                    origin: origin,
                    originControlPoint: originControlPoint,
                    end: end,
                    endControlPoint: endControlPoint
                ))
            }
            
            if index == triplets.count - 1 {
                if nextStraightEdge.length.isGreaterThanZero() {
                    result.addLinearEdge(nextStraightEdge)
                }
            }
        }
        result.removeRedundantEdges()
        return result
    }
    
    public func toString(decimalPlaces: Int = 2) -> String {
        return "[\(self.vertices.map({ $0.toString(decimalPlaces: decimalPlaces) }).joined(separator: ", "))]"
    }
    
    // MARK: - Constructors
    
    public init(vertices: [SMPoint]) {
        self.vertices = vertices
    }
    
    public init(vertices: SMPoint...) {
        self.init(vertices: vertices)
    }
    
    // MARK: - Operations
    
    public static func + (left: SMPolyline, right: SMPoint) -> SMPolyline {
        return SMPolyline(vertices: left.vertices.map({ $0 + right }))
    }

    public static func += (left: inout SMPolyline, right: SMPoint) {
        left = left + right
    }

    public static func - (left: SMPolyline, right: SMPoint) -> SMPolyline {
        return SMPolyline(vertices: left.vertices.map({ $0 - right }))
    }

    public static func -= (left: inout SMPolyline, right: SMPoint) {
        left = left - right
    }
    
    public static func == (lhs: SMPolyline, rhs: SMPolyline) -> Bool {
        guard lhs.vertices.count == rhs.vertices.count else {
            return false
        }
        for index in lhs.vertices.indices {
            if lhs.vertices[index] != rhs.vertices[index] {
                return false
            }
        }
        return true
    }
    
    // MARK: - Core Graphics
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        guard let first = self.vertices.first else {
            return path
        }
        path.move(to: first.cgPoint)
        path.addLines(between: self.vertices.map({ $0.cgPoint }))
        return path
    }
    
    public var cgPathValidated: CGPath? {
        guard self.isValid else {
            return nil
        }
        return self.cgPath
    }
    
}
