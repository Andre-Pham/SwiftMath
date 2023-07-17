//
//  SMSize.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

public class SMSize: SMClonable {
    
    // MARK: - Properties
    
    public var width: Double
    public var height: Double
    
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
    
    public init(_ cgSize: CGSize) {
        self.width = cgSize.width
        self.height = cgSize.height
    }
    
}
