//
//  SMRect.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation
import CoreGraphics

public class SMRect: SMGeometry, SMClonable, Equatable {
    
    // MARK: - Properties
    
    /// The bottom left of the rectangle
    public var origin: SMPoint
    /// The top right of the rectangle
    public var end: SMPoint
    /// This geometry's vertices (ordered)
    public var vertices: [SMPoint] {
        return [
            self.origin.clone(),                            // Bottom left
            self.origin + SMPoint(x: 0.0, y: self.height),  // Top left
            self.end.clone(),                               // Top right
            self.origin + SMPoint(x: self.width, y: 0.0)    // Bottom right
        ]
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
        return SMPoint(x: (self.width)/2.0, y: (self.height)/2.0)
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
        return SM.isLess(self.minY, self.maxY) && SM.isLess(self.minX, self.maxX)
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
    
    public func union(_ other: SMRect) -> SMRect {
        return SMRect(self.cgRect.union(other.cgRect))
    }
    
    public func intersection(_ other: SMRect) -> SMRect {
        return SMRect(self.cgRect.intersection(other.cgRect))
    }
    
    public func intersects(with other: SMRect) -> Bool {
        return self.cgRect.intersects(other.cgRect)
    }
    
    public func scale(toAspectFillSize size: SMSize) -> SMRect {
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
        return SMRect(origin: SMPoint(x: x, y: y), width: scaledWidth, height: scaledHeight)
    }
    
    public func scale(toAspectFitSize size: SMSize) -> SMRect {
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
        return SMRect(origin: SMPoint(x: x, y: y), width: scaledWidth, height: scaledHeight)
    }
    
    /// If a point is contained inside of this rect (including on an edge).
    /// - Parameters:
    ///   - point: The point to check
    /// - Returns: True if the point is contained inside (including on the edge)
    public func contains(point: SMPoint) -> Bool {
        return (
            SM.isLessOrEqual(point.x, self.maxX)
            && SM.isGreaterOrEqual(point.x, self.minX)
            && SM.isLessOrEqual(point.y, self.maxY)
            && SM.isGreaterOrEqual(point.y, self.minY)
        )
    }
    
    /// If a point is enclosed inside of this rect (NOT including on an edge).
    /// - Parameters:
    ///   - point: The point to check
    /// - Returns: True if the point is enclosed inside (NOT including on the edge)
    public func encloses(point: SMPoint) -> Bool {
        return (
            SM.isLessOrEqual(point.x, self.maxX)
            && SM.isGreaterOrEqual(point.x, self.minX)
            && SM.isLessOrEqual(point.y, self.maxY)
            && SM.isGreaterOrEqual(point.y, self.minY)
        )
    }
    
    /// If a rectangle is contained inside of this rect (including overlapping edges).
    /// - Parameters:
    ///   - point: The point to check
    /// - Returns: True if the rectangle is contained inside (including overlapping edges)
    public func contains(rect: SMRect) -> Bool {
        return (
            SM.isLessOrEqual(rect.maxX, self.maxX)
            && SM.isGreaterOrEqual(rect.minX, self.minX)
            && SM.isLessOrEqual(rect.maxY, self.maxY)
            && SM.isGreaterOrEqual(rect.minY, self.minY)
        )
    }
    
    /// If a rectangle is enclosed inside of this rect (NOT including overlapping edges).
    /// - Parameters:
    ///   - point: The point to check
    /// - Returns: True if the rectangle is enclosed inside (NOT including overlapping edges)
    public func encloses(rect: SMRect) -> Bool {
        return (
            SM.isLess(rect.maxX, self.maxX)
            && SM.isGreater(rect.minX, self.minX)
            && SM.isLess(rect.maxY, self.maxY)
            && SM.isGreater(rect.minY, self.minY)
        )
    }
    
    // MARK: - Transformations
    
    public func translate(by point: SMPoint) {
        self.origin += point
        self.end += point
    }
    
    /// Rotates the center of this rectangle around a point
    public func rotate(around center: SMPoint, by angle: SMAngle) {
        let rectCenter = self.center
        rectCenter.rotate(around: center, by: angle)
        let newRect = SMRect(center: rectCenter, width: self.width, height: self.height)
        self.origin = newRect.origin
        self.end = newRect.end
    }
    
    // MARK: - Operations
    
    public static func == (lhs: SMRect, rhs: SMRect) -> Bool {
        return lhs.origin == rhs.origin && lhs.end == rhs.end
    }
    
    // MARK: - Core Graphics
    
    public var cgRect: CGRect {
        return CGRect(origin: self.origin.cgPoint, size: CGSize(width: self.width, height: self.height))
    }
    
    public init(_ cgRect: CGRect) {
        self.origin = SMPoint(cgRect.origin)
        var end = cgRect.origin
        end.x += cgRect.size.width
        end.y += cgRect.size.height
        self.end = SMPoint(end)
    }
    
}
