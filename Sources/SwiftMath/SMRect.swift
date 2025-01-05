//
//  SMRect.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation
import CoreGraphics

/// Represents a rectangle.
public struct SMRect: SMGeometry {
    
    // MARK: - Properties
    
    /// Min x of the rectangle
    public var minX: Double
    /// Min y of the rectangle
    public var minY: Double
    /// Max x of the rectangle
    public var maxX: Double
    /// Max y of the rectangle
    public var maxY: Double
    /// This geometry's vertices (ordered)
    public var vertices: [SMPoint] {
        return [self.minXminY, self.minXmaxY, self.maxXmaxY, self.maxXminY]
    }
    /// The corner with the min x and min y
    public var minXminY: SMPoint {
        return SMPoint(x: self.minX, y: self.minY)
    }
    /// The corner with the min x and max y
    public var minXmaxY: SMPoint {
        return SMPoint(x: self.minX, y: self.maxY)
    }
    /// The corner with the max x and min y
    public var maxXminY: SMPoint {
        return SMPoint(x: self.maxX, y: self.minY)
    }
    /// The corner with the max x and max y
    public var maxXmaxY: SMPoint {
        return SMPoint(x: self.maxX, y: self.maxY)
    }
    /// The corner with the min x and min y
    public var minCorner: SMPoint {
        self.minXminY
    }
    /// The corner with the max x and max y
    public var maxCorner: SMPoint {
        self.maxXmaxY
    }
    /// This geometry's edges (ordered)
    public var edges: [SMLineSegment] {
        let vertices = self.vertices
        return [
            SMLineSegment(origin: vertices[0], end: vertices[1]),
            SMLineSegment(origin: vertices[1], end: vertices[2]),
            SMLineSegment(origin: vertices[2], end: vertices[3]),
            SMLineSegment(origin: vertices[3], end: vertices[0])
        ]
    }
    /// The center of the rectangle
    public var center: SMPoint {
        return SMPoint(x: (self.minX + self.maxX)/2.0, y: (self.minY + self.maxY)/2.0)
    }
    /// The rectangle width
    public var width: Double {
        return self.maxX - self.minX
    }
    /// The rectangle height
    public var height: Double {
        return self.maxY - self.minY
    }
    /// The rectangle area
    public var area: Double {
        return self.width*self.height
    }
    /// The perimeter of the rectangle
    public var perimeter: Double {
        return self.width*2.0 + self.height*2.0
    }
    /// If the rectangle is valid
    public var isValid: Bool {
        return self.minY.isLess(than: self.maxY) && self.minX.isLess(than: self.maxY)
    }
    /// The size of the rect
    public var size: SMSize {
        return SMSize(width: self.width, height: self.height)
    }
    
    // MARK: - Constructors
    
    public init(minCorner: SMPoint, maxCorner: SMPoint) {
        self.minX = minCorner.x
        self.minY = minCorner.y
        self.maxX = maxCorner.x
        self.maxY = maxCorner.y
    }
    
    public init(minX: Double, minY: Double, maxX: Double, maxY: Double) {
        self.minX = minX
        self.minY = minY
        self.maxX = maxX
        self.maxY = maxY
    }
    
    public init(center: SMPoint, width: Double, height: Double) {
        self.minX = center.x - width/2.0
        self.minY = center.y - height/2.0
        self.maxX = center.x + width/2.0
        self.maxY = center.y + height/2.0
    }
    
    public init(minCorner: SMPoint, width: Double, height: Double) {
        self.init(minCorner: minCorner, maxCorner: minCorner + SMPoint(x: width, y: height))
    }
    
    // MARK: - Functions
    
    /// Calculates the smallest rectangle that completely encompasses both of the input rectangles.
    /// - Parameters:
    ///   - other: The other rectangle to form a union
    /// - Returns: The union of the two rectangles
    public func union(_ other: SMRect) -> SMRect {
        return SMRect(self.cgRect.union(other.cgRect))
    }
    
    /// Calculates the smallest rectangle with a valid area that represents the overlap between the two input rectangles.
    /// - Parameters:
    ///   - other: The other rectangle to form an overlapping rectangle
    /// - Returns: The union of the two rectangles
    public func overlap(_ other: SMRect) -> SMRect? {
        guard self.cgRect.intersects(other.cgRect) else {
            return nil
        }
        return SMRect(self.cgRect.intersection(other.cgRect))
    }
    
    /// Calculates if there is an intersecting point between two rectangles (doesn't count overlapping edges).
    /// - Parameters:
    ///   - other: The other rectangle to check
    /// - Returns: True if the rectangles intersect without their edges overlapping
    public func intersects(with other: SMRect) -> Bool {
        if self.overlap(other) != nil && !self.contains(rect: other) && !other.contains(rect: self) {
            return true
        }
        return (
            self.maxXmaxY == other.minXminY
            || self.minXminY == other.maxXmaxY
            || self.minXmaxY == other.maxXminY
            || self.maxXminY == other.minXmaxY
        )
    }
    
    /// Calculates if two rectangles touch edges without overlapping.
    /// - Parameters:
    ///   - other: The other rectangle to check
    /// - Returns: True if the rectangles touch without overlapping
    public func touches(_ other: SMRect) -> Bool {
        for edge in self.edges {
            for otherEdge in other.edges {
                if edge.overlaps(with: otherEdge) {
                    return true
                }
            }
        }
        return (
            self.maxXmaxY == other.minXminY
            || self.minXminY == other.maxXmaxY
            || self.minXmaxY == other.maxXminY
            || self.maxXminY == other.minXmaxY
        )
    }
    
    /// Checks if this rectangle has some spatial relationship (intersection, containment, overlap, etc.) with another rectangle.
    /// - Parameters:
    ///   - other: The other rectangle to compare against
    /// - Returns: True if the two rectangles are spatially related
    public func relates(to other: SMRect) -> Bool {
        return self.intersects(with: other) || self.touches(other) || self.encloses(rect: other) || other.encloses(rect: self)
    }
    
    /// Scale this rect from the center to fill the given size whilst maintaining the same aspect ratio.
    /// - Parameters:
    ///   - size: The size to scale to (to fill)
    public mutating func scale(toAspectFillSize size: SMSize) {
        let aspectRatio = size.width / size.height
        let rectRatio = self.width / self.height
        var scale: CGFloat = 1.0
        if aspectRatio > rectRatio {
            // Scale based on width
            scale = size.width / self.width
        } else {
            // Scale based on height
            scale = size.height / self.height
        }
        let scaledWidth = self.width * scale
        let scaledHeight = self.height * scale
        let x = self.minCorner.x - (scaledWidth - self.width) / 2
        let y = self.minCorner.y - (scaledHeight - self.height) / 2
        self.minX = x
        self.minY = y
        self.maxX = x + scaledWidth
        self.maxY = y + scaledHeight
    }
    
    /// Scale this rect from the center to fit the given size whilst maintaining the same aspect ratio.
    /// - Parameters:
    ///   - size: The size to scale to (to fit)
    public mutating func scale(toAspectFitSize size: SMSize) {
        let aspectRatio = size.width / size.height
        let rectRatio = self.width / self.height
        var scale: CGFloat = 1.0
        if aspectRatio < rectRatio {
            // Scale based on width
            scale = size.width / self.width
        } else {
            // Scale based on height
            scale = size.height / self.height
        }
        let scaledWidth = self.width * scale
        let scaledHeight = self.height * scale
        let x = self.minCorner.x + (self.width - scaledWidth) / 2
        let y = self.minCorner.y + (self.height - scaledHeight) / 2
        self.minX = x
        self.minY = y
        self.maxX = x + scaledWidth
        self.maxY = y + scaledHeight
    }
    
    /// Expand each side away from the center of the rect by specified magnitudes.
    /// - Parameters:
    ///   - minX: The amount of horizontal translation the min x side of the rect receives (away from the center)
    ///   - minY: The amount of vertical translation the min y side of the rect receives (away from the center)
    ///   - maxX: The amount of horizontal translation the max x side of the rect receives (away from the center)
    ///   - maxY: The amount of vertical translation the max y side of the rect receives (away from the center)
    public mutating func expand(minX: Double = 0.0, minY: Double = 0.0, maxX: Double = 0.0, maxY: Double = 0.0) {
        self.minX -= minX
        self.minY -= minY
        self.maxX += maxX
        self.maxY += maxY
    }
    
    /// Expand each side away from the center by a certain magnitude.
    /// - Parameters:
    ///   - amount: The amount of translation each side of the rect receives (away from the center)
    public mutating func expandAllSides(by amount: Double) {
        self.expand(minX: amount, minY: amount, maxX: amount, maxY: amount)
    }
    
    /// If a point is contained inside of this rect (including on an edge).
    /// - Parameters:
    ///   - point: The point to check
    /// - Returns: True if the point is contained inside (including on the edge)
    public func contains(point: SMPoint) -> Bool {
        return (
            point.x.isLessOrEqual(to: self.maxX)
            && point.x.isGreaterOrEqual(to: self.minX)
            && point.y.isLessOrEqual(to: self.maxY)
            && point.y.isGreaterOrEqual(to: self.minY)
        )
    }
    
    /// If a point is enclosed inside of this rect (NOT including on an edge).
    /// - Parameters:
    ///   - point: The point to check
    /// - Returns: True if the point is enclosed inside (NOT including on the edge)
    public func encloses(point: SMPoint) -> Bool {
        return (
            point.x.isLess(than: self.maxX)
            && point.x.isGreater(than: self.minX)
            && point.y.isLess(than: self.maxY)
            && point.y.isGreater(than: self.minY)
        )
    }
    
    /// If a rectangle is contained inside of this rect (including overlapping edges).
    /// - Parameters:
    ///   - point: The point to check
    /// - Returns: True if the rectangle is contained inside (including overlapping edges)
    public func contains(rect: SMRect) -> Bool {
        return (
            rect.maxX.isLessOrEqual(to: self.maxX)
            && rect.minX.isGreaterOrEqual(to: self.minX)
            && rect.maxY.isLessOrEqual(to: self.maxY)
            && rect.minY.isGreaterOrEqual(to: self.minY)
        )
    }
    
    /// If a rectangle is enclosed inside of this rect (NOT including overlapping edges).
    /// - Parameters:
    ///   - point: The point to check
    /// - Returns: True if the rectangle is enclosed inside (NOT including overlapping edges)
    public func encloses(rect: SMRect) -> Bool {
        return (
            rect.maxX.isLess(than: self.maxX)
            && rect.minX.isGreater(than: self.minX)
            && rect.maxY.isLess(than: self.maxY)
            && rect.minY.isGreater(than: self.minY)
        )
    }
    
    public func contains(geometry: any SMGeometry) -> Bool {
        guard self.isValid else {
            return false
        }
        guard let geometryBoundingBox = geometry.boundingBox,
              self.contains(rect: geometryBoundingBox) else {
            return false
        }
        for vertex in geometry.vertices {
            if !self.contains(point: vertex) {
                return false
            }
        }
        return true
    }
    
    public func encloses(geometry: any SMGeometry) -> Bool {
        guard self.isValid else {
            return false
        }
        guard let geometryBoundingBox = geometry.boundingBox,
              self.encloses(rect: geometryBoundingBox) else {
            return false
        }
        for vertex in geometry.vertices {
            if !self.encloses(point: vertex) {
                return false
            }
        }
        return true
    }
    
    public func toString(decimalPlaces: Int = 2) -> String {
        return "Rect\n- Left: \(self.minX.rounded(decimalPlaces: decimalPlaces))\n- Right: \(self.maxX.rounded(decimalPlaces: decimalPlaces))\n- Top: \(self.maxY.rounded(decimalPlaces: decimalPlaces))\n- Bottom: \(self.minY.rounded(decimalPlaces: decimalPlaces))\n- Width: \(self.width.rounded(decimalPlaces: decimalPlaces))\n- Height: \(self.height.rounded(decimalPlaces: decimalPlaces))"
    }
    
    // MARK: - Transformations
    
    public mutating func translate(by point: SMPoint) {
        self.minX += point.x
        self.minY += point.y
        self.maxX += point.x
        self.maxY += point.y
    }
    
    public mutating func translateCenter(to point: SMPoint) {
        self.translate(by: point - self.center)
    }
    
    /// Rotates the center of this rectangle around a point
    public mutating func rotate(around center: SMPoint, by angle: SMAngle) {
        var rectCenter = self.center
        rectCenter.rotate(around: center, by: angle)
        let newRect = SMRect(center: rectCenter, width: self.width, height: self.height)
        self.minX = newRect.minX
        self.minY = newRect.minY
        self.maxX = newRect.maxX
        self.maxY = newRect.maxY
    }
    
    public mutating func scale(from point: SMPoint, scale: Double) {
        self.translate(by: point * -1)
        self.minX *= scale
        self.minY *= scale
        self.maxX *= scale
        self.maxY *= scale
        self.translate(by: point)
    }
    
    // MARK: - Operations
    
    public static func + (left: SMRect, right: SMPoint) -> SMRect {
        return SMRect(minCorner: left.minCorner + right, maxCorner: left.maxCorner + right)
    }

    public static func += (left: inout SMRect, right: SMPoint) {
        left = left + right
    }

    public static func - (left: SMRect, right: SMPoint) -> SMRect {
        return SMRect(minCorner: left.minCorner - right, maxCorner: left.maxCorner - right)
    }

    public static func -= (left: inout SMRect, right: SMPoint) {
        left = left - right
    }
    
    public static func == (lhs: SMRect, rhs: SMRect) -> Bool {
        return lhs.minX.isEqual(to: rhs.minX) && lhs.minY.isEqual(to: rhs.minY) && lhs.maxX.isEqual(to: rhs.maxX) && lhs.maxY.isEqual(to: rhs.maxY)
    }
    
    // MARK: - Core Graphics
    
    public var cgRect: CGRect {
        return CGRect(origin: self.minCorner.cgPoint, size: CGSize(width: self.width, height: self.height))
    }
    
    public var cgRectValidated: CGRect? {
        guard self.isValid else {
            return nil
        }
        return self.cgRect
    }
    
    public init(_ cgRect: CGRect) {
        self.minX = cgRect.minX
        self.minY = cgRect.minY
        self.maxX = cgRect.maxX
        self.maxY = cgRect.maxY
    }
    
}
