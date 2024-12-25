//
//  SMSize.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

/// Represents width and height dimensions.
public struct SMSize {
    
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
