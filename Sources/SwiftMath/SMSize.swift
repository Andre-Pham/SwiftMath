//
//  SMSize.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

/// Represents width and height dimensions.
public struct SMSize: Equatable {
    
    // MARK: - Properties
    
    /// The size's width
    public var width: Double
    /// The size's height
    public var height: Double
    /// The size's area
    public var area: Double {
        return self.width*self.height
    }
    /// If the size is valid
    public var isValid: Bool {
        return self.width.isGreaterThanZero() && self.height.isGreaterThanZero()
    }
    
    // MARK: - Constructors
    
    public init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    // MARK: - Functions
    
    /// Scale this size to fill the given size whilst maintaining the same aspect ratio.
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
        self.width *= scale
        self.height *= scale
    }
    
    /// Scale this size to fit the given size whilst maintaining the same aspect ratio.
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
        self.width *= scale
        self.height *= scale
    }
    
    public func toString(decimalPlaces: Int = 2) -> String {
        return "\(self.width.rounded(decimalPlaces: decimalPlaces)) x \(self.height.rounded(decimalPlaces: decimalPlaces))"
    }
    
    // MARK: - Operations
    
    public static func == (lhs: SMSize, rhs: SMSize) -> Bool {
        return lhs.width.isEqual(to: rhs.width) && lhs.height.isEqual(to: rhs.height)
    }
    
    // MARK: - Core Graphics
    
    public var cgSize: CGSize {
        return CGSize(width: self.width, height: self.height)
    }
    
    public var cgSizeValidated: CGSize? {
        guard self.isValid else {
            return nil
        }
        return self.cgSize
    }
    
    public init(_ cgSize: CGSize) {
        self.width = cgSize.width
        self.height = cgSize.height
    }
    
}
