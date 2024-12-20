//
//  SMRect.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation
import CoreGraphics

/// Represents a rectangle.
public final class SMRect: SMGeometry, SMClonable {
    
    // MARK: - Properties
    
    /// The bottom left of the rectangle
    public var origin: SMPoint
    /// The top right of the rectangle
    public var end: SMPoint
    /// This geometry's vertices (ordered)
    public var vertices: [SMPoint] {
        return [self.bottomLeft, self.topLeft, self.topRight, self.bottomRight]
    }
    /// The top left point
    public var topLeft: SMPoint {
        return self.origin + SMPoint(x: 0.0, y: self.height)
    }
    /// The top right point
    public var topRight: SMPoint {
        return self.end.clone()
    }
    /// The bottom left point
    public var bottomLeft: SMPoint {
        return self.origin.clone()
    }
    /// The bottom right point
    public var bottomRight: SMPoint {
        return self.origin + SMPoint(x: self.width, y: 0.0)
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
    /// Min x of the rectangle
    public var minX: Double {
        return self.origin.x
    }
    /// Min y of the rectangle
    public var minY: Double {
        return self.origin.y
    }
    /// Max x of the rectangle
    public var maxX: Double {
        return self.end.x
    }
    /// Max y of the rectangle
    public var maxY: Double {
        return self.end.y
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
    
    // MARK: - Constructors
    
    public init(origin: SMPoint, end: SMPoint) {
        self.origin = origin.clone()
        self.end = end.clone()
    }
    
    public init(minX: Double, maxX: Double, minY: Double, maxY: Double) {
        self.origin = SMPoint(x: minX, y: minY)
        self.end = SMPoint(x: maxX, y: maxY)
    }
    
    public init(center: SMPoint, width: Double, height: Double) {
        self.origin = center - SMPoint(x: width/2.0, y: height/2.0)
        self.end = center + SMPoint(x: width/2.0, y: height/2.0)
    }
    
    public convenience init(origin: SMPoint, width: Double, height: Double) {
        self.init(origin: origin, end: origin + SMPoint(x: width, y: height))
    }
    
    public required init(_ original: SMRect) {
        self.origin = original.origin.clone()
        self.end = original.end.clone()
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
            self.topRight == other.bottomLeft
            || self.bottomLeft == other.topRight
            || self.topLeft == other.bottomRight
            || self.bottomRight == other.topLeft
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
            self.topRight == other.bottomLeft
            || self.bottomLeft == other.topRight
            || self.topLeft == other.bottomRight
            || self.bottomRight == other.topLeft
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
    public func scale(toAspectFillSize size: SMSize) {
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
        let x = self.origin.x - (scaledWidth - self.width) / 2
        let y = self.origin.y - (scaledHeight - self.height) / 2
        self.origin = SMPoint(x: x, y: y)
        self.end = SMPoint(x: x + scaledWidth, y: y + scaledHeight)
    }
    
    /// Scale this rect from the center to fit the given size whilst maintaining the same aspect ratio.
    /// - Parameters:
    ///   - size: The size to scale to (to fit)
    public func scale(toAspectFitSize size: SMSize) {
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
        let x = self.origin.x + (self.width - scaledWidth) / 2
        let y = self.origin.y + (self.height - scaledHeight) / 2
        self.origin = SMPoint(x: x, y: y)
        self.end = SMPoint(x: x + scaledWidth, y: y + scaledHeight)
    }
    
    /// Expand each side away from the center of the rect by specified magnitudes.
    /// - Parameters:
    ///   - left: The amount of horizontal translation the left side of the rect receives (away from the center)
    ///   - right: The amount of horizontal translation the right side of the rect receives (away from the center)
    ///   - top: The amount of vertical translation the top side of the rect receives (away from the center)
    ///   - bottom: The amount of vertical translation the bottom side of the rect receives (away from the center)
    public func expand(left: Double = 0.0, right: Double = 0.0, top: Double = 0.0, bottom: Double = 0.0) {
        self.origin.x -= left
        self.origin.y -= bottom
        self.end.x += right
        self.end.y += top
    }
    
    /// Expand each side away from the center by a certain magnitude.
    /// - Parameters:
    ///   - amount: The amount of translation each side of the rect receives (away from the center)
    public func expandAllSides(by amount: Double) {
        self.expand(left: amount, right: amount, top: amount, bottom: amount)
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
        return "Left: \(self.minX.rounded(decimalPlaces: decimalPlaces))\nRight: \(self.maxX.rounded(decimalPlaces: decimalPlaces))\nTop: \(self.maxY.rounded(decimalPlaces: decimalPlaces))\nBottom: \(self.minY.rounded(decimalPlaces: decimalPlaces))\nWidth: \(self.width.rounded(decimalPlaces: decimalPlaces))\nHeight: \(self.height.rounded(decimalPlaces: decimalPlaces))"
    }
    
    // MARK: - Transformations
    
    public func translate(by point: SMPoint) {
        self.origin += point
        self.end += point
    }
    
    public func translateCenter(to point: SMPoint) {
        self.translate(by: point - self.center)
    }
    
    /// Rotates the center of this rectangle around a point
    public func rotate(around center: SMPoint, by angle: SMAngle) {
        let rectCenter = self.center
        rectCenter.rotate(around: center, by: angle)
        let newRect = SMRect(center: rectCenter, width: self.width, height: self.height)
        self.origin = newRect.origin
        self.end = newRect.end
    }
    
    public func scale(from point: SMPoint, scale: Double) {
        self.translate(by: point * -1)
        self.origin *= scale
        self.end *= scale
        self.translate(by: point)
    }
    
    // MARK: - Operations
    
    public static func + (left: SMRect, right: SMPoint) -> SMRect {
        return SMRect(origin: left.origin + right, end: left.end + right)
    }

    public static func += (left: inout SMRect, right: SMPoint) {
        left = left + right
    }

    public static func - (left: SMRect, right: SMPoint) -> SMRect {
        return SMRect(origin: left.origin - right, end: left.end - right)
    }

    public static func -= (left: inout SMRect, right: SMPoint) {
        left = left - right
    }
    
    public static func == (lhs: SMRect, rhs: SMRect) -> Bool {
        return lhs.origin == rhs.origin && lhs.end == rhs.end
    }
    
    // MARK: - Core Graphics
    
    public var cgRect: CGRect {
        return CGRect(origin: self.origin.cgPoint, size: CGSize(width: self.width, height: self.height))
    }
    
    public var cgRectValidated: CGRect? {
        guard self.isValid else {
            return nil
        }
        return self.cgRect
    }
    
    public init(_ cgRect: CGRect) {
        self.origin = SMPoint(cgRect.origin)
        var end = cgRect.origin
        end.x += cgRect.size.width
        end.y += cgRect.size.height
        self.end = SMPoint(end)
    }
    
}
