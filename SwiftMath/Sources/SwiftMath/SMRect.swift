//
//  SMRect.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation
import CoreGraphics

class SMRect: SMClonable, Equatable {
    
    // MARK: - Properties
    
    /// The bottom left of the rectangle
    public var origin: SMPoint
    /// The top right of the rectangle
    public var end: SMPoint
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
        return SMPoint(x: (self.maxX - self.minX)/2.0, y: (self.maxY - self.minY)/2.0)
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
        return isGreaterZero(self.area)
    }
    
    // MARK: - Constructors
    
    init(origin: SMPoint, end: SMPoint) {
        self.origin = origin.clone()
        self.end = end.clone()
    }
    
    convenience init(origin: SMPoint, width: Double, height: Double) {
        self.init(origin: origin, end: origin + SMPoint(x: width, y: height))
    }
    
    required init(_ original: SMRect) {
        self.origin = original.origin.clone()
        self.end = original.end.clone()
    }
    
    // MARK: - Functions
    
    func union(_ other: SMRect) -> SMRect {
        return SMRect(self.cgRect.union(other.cgRect))
    }
    
    func intersection(_ other: SMRect) -> SMRect {
        return SMRect(self.cgRect.intersection(other.cgRect))
    }
    
    func intersects(with other: SMRect) -> Bool {
        return self.cgRect.intersects(other.cgRect)
    }
    
    func scale(toAspectFillSize size: SMSize) -> SMRect {
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
    
    func scale(toAspectFitSize size: SMSize) -> SMRect {
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
    
    func offset(by point: SMPoint) {
        self.origin += point
        self.end += point
    }
    
    // MARK: - Operations
    
    static func == (lhs: SMRect, rhs: SMRect) -> Bool {
        return lhs.origin == rhs.origin && lhs.end == rhs.end
    }
    
    // MARK: - Core Graphics
    
    public var cgRect: CGRect {
        return CGRect(origin: self.origin.cgPoint, size: CGSize(width: self.width, height: self.height))
    }
    
    init(_ cgRect: CGRect) {
        self.origin = SMPoint(cgRect.origin)
        var end = cgRect.origin
        end.x += cgRect.size.width
        end.y += cgRect.size.height
        self.end = SMPoint(end)
    }
    
}
