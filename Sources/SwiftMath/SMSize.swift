//
//  SMSize.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

open class SMSize: SMClonable {
    
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
        return SM.isGreaterZero(self.width) && SM.isGreaterZero(self.height)
    }
    
    // MARK: - Constructors
    
    public init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    public required init(_ original: SMSize) {
        self.width = original.width
        self.height = original.height
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
