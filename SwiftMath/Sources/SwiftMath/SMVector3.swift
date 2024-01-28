//
//  SMVector3.swift
//  
//
//  Created by Andre Pham on 18/7/2023.
//

import Foundation
import SceneKit

public class SMVector3: SMClonable, Equatable {
    
    // MARK: - Properties
    
    public var x: Double
    public var y: Double
    public var z: Double
    public var magnitude: Double {
        return sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
    }
    
    // MARK: - Constructors
    
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public convenience init() {
        self.init(x: 0.0, y: 0.0, z: 0.0)
    }
    
    public convenience init(x: Float, y: Float, z: Float) {
        self.init(x: Double(x), y: Double(y), z: Double(z))
    }
    
    public required init(_ original: SMVector3) {
        self.x = original.x
        self.y = original.y
        self.z = original.z
    }
    
    // MARK: - Functions
    
    /// Normalizes this vector
    public func normalize() {
        let mag = self.magnitude
        if !SM.isZero(mag) {
            self.x /= mag
            self.y /= mag
            self.z /= mag
        }
    }
    
    /// Creates a new vector from this vector but normalized
    /// - Returns: This a new normalised vector
    public func normalized() -> SMVector3 {
        let result = self.clone()
        result.normalize()
        return result
    }
    
    /// Computes the dot product of this vector and another vector
    /// - Parameters:
    ///   - other: The other vector to calculate the dot product with
    /// - Returns: The dot product
    public func dot(_ other: SMVector3) -> Double {
        return self.x * other.x + self.y * other.y + self.z * other.z
    }
    
    /// Computes the cross product of this vector and another vector
    /// - Parameters:
    ///   - other: The other vector to calculate the cross product with
    /// - Returns: The cross product
    public func cross(_ other: SMVector3) -> SMVector3 {
        let newX = self.y * other.z - self.z * other.y
        let newY = self.z * other.x - self.x * other.z
        let newZ = self.x * other.y - self.y * other.x
        return SMVector3(x: newX, y: newY, z: newZ)
    }
    
    public func length(to vector: SMVector3) -> Double {
        return sqrt(
            pow(vector.x - self.x, 2) +
            pow(vector.y - self.y, 2) +
            pow(vector.z - self.z, 2)
        )
    }

    // MARK: - Operations

    public static func + (left: SMVector3, right: SMVector3) -> SMVector3 {
        return SMVector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
    }

    public static func += (left: inout SMVector3, right: SMVector3) {
        left = left + right
    }

    public static func - (left: SMVector3, right: SMVector3) -> SMVector3 {
        return SMVector3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
    }

    public static func -= (left: inout SMVector3, right: SMVector3) {
        left = left - right
    }

    public static func * (vector: SMVector3, scalar: Double) -> SMVector3 {
        return SMVector3(x: vector.x * scalar, y: vector.y * scalar, z: vector.z * scalar)
    }

    public static func *= (vector: inout SMVector3, scalar: Double) {
        vector = vector * scalar
    }

    public static func / (vector: SMVector3, scalar: Double) -> SMVector3 {
        guard !SM.isZero(scalar) else {
            fatalError("Division by zero is illegal")
        }
        return SMVector3(x: vector.x / scalar, y: vector.y / scalar, z: vector.z / scalar)
    }

    public static func /= (vector: inout SMVector3, scalar: Double) {
        vector = vector / scalar
    }

    public static func == (lhs: SMVector3, rhs: SMVector3) -> Bool {
        return SM.isEqual(lhs.x, rhs.x) && SM.isEqual(lhs.y, rhs.y) && SM.isEqual(lhs.z, rhs.z)
    }
    
    // MARK: - SceneKit
    
    public var scnVector3: SCNVector3 {
        return SCNVector3(self.x, self.y, self.z)
    }
    
    public init(_ scnVector3: SCNVector3) {
        self.x = Double(scnVector3.x)
        self.y = Double(scnVector3.y)
        self.z = Double(scnVector3.z)
    }
    
}
