//
//  SMAngle.swift
//  
//
//  Created by Andre Pham on 17/7/2023.
//

import Foundation

struct SMAngle: SMClonable {
    
    public let radians: Double
    public var degrees: Double {
        return self.radians * 180.0 / .pi
    }
    
    init(radians: Float) {
        self.radians = Double(radians)
    }
    
    init(degrees: Float) {
        self.radians = Double(degrees * .pi / 180.0)
    }
    
    init(radians: Double) {
        self.radians = radians
    }
    
    init(degrees: Double) {
        self.radians = degrees * .pi / 180.0
    }
    
    init(_ original: SMAngle) {
        self.radians = original.radians
    }
    
}
