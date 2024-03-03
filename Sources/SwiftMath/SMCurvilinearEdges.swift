//
//  SMCurvilinearEdges.swift
//
//
//  Created by Andre Pham on 29/2/2024.
//

import Foundation
import CoreGraphics

open class SMCurvilinearEdges: SMClonable {
    
    // MARK: - Properties
    
    private var linearEdges = [Int: SMLineSegment]()
    private var bezierEdges = [Int: SMBezierCurve]()
    private var quadEdges = [Int: SMQuadCurve]()
    private var arcEdges = [Int: SMArc]()
    private(set) var edgeCount = 0
    public var lastPoint: SMPoint? {
        guard self.edgeCount > 0 else {
            return nil
        }
        if let last = self.linearEdges[self.edgeCount - 1] {
            return last.end
        } else if let last = self.bezierEdges[self.edgeCount - 1] {
            return last.end
        } else if let last = self.quadEdges[self.edgeCount - 1] {
            return last.end
        } else if let last = self.arcEdges[self.edgeCount - 1] {
            return last.endPoint
        }
        return nil
    }
    public var assortedLinearEdges: [SMLineSegment] {
        return Array(self.linearEdges.values)
    }
    public var assortedBezierEdges: [SMBezierCurve] {
        return Array(self.bezierEdges.values)
    }
    public var assortedQuadEdges: [SMQuadCurve] {
        return Array(self.quadEdges.values)
    }
    public var assortedArcEdges: [SMArc] {
        return Array(self.arcEdges.values)
    }
    
    // MARK: - Constructors
    
    public init() { }
    
    public required init(_ original: SMCurvilinearEdges) {
        self.linearEdges = original.linearEdges.clone()
        self.bezierEdges = original.bezierEdges.clone()
        self.quadEdges = original.quadEdges.clone()
        self.arcEdges = original.arcEdges.clone()
    }
    
    // MARK: - Functions
    
    public func addLinearEdge(_ edge: SMLineSegment) {
        self.linearEdges[self.edgeCount] = edge
        self.edgeCount += 1
    }
    
    public func addBezierEdge(_ edge: SMBezierCurve) {
        self.bezierEdges[self.edgeCount] = edge
        self.edgeCount += 1
    }
    
    public func addQuadEdge(_ edge: SMQuadCurve) {
        self.quadEdges[self.edgeCount] = edge
        self.edgeCount += 1
    }
    
    public func addArcEdge(_ edge: SMArc) {
        self.arcEdges[self.edgeCount] = edge
        self.edgeCount += 1
    }
    
    public func removeEdge(at index: Int) {
        let linearRemoved = self.linearEdges.removeValue(forKey: index) != nil
        let bezierRemoved = self.bezierEdges.removeValue(forKey: index) != nil
        let quadRemoved = self.quadEdges.removeValue(forKey: index) != nil
        let arcRemoved = self.arcEdges.removeValue(forKey: index) != nil
        let edgeWasRemoved = linearRemoved || bezierRemoved || quadRemoved || arcRemoved
        guard edgeWasRemoved else {
            return
        }
        self.edgeCount -= 1
        for (key, value) in self.linearEdges {
            if key > index {
                self.linearEdges[key - 1] = value
            }
        }
        for (key, value) in self.bezierEdges {
            if key > index {
                self.bezierEdges[key - 1] = value
            }
        }
        for (key, value) in self.quadEdges {
            if key > index {
                self.quadEdges[key - 1] = value
            }
        }
        for (key, value) in self.arcEdges {
            if key > index {
                self.arcEdges[key - 1] = value
            }
        }
        self.linearEdges.removeValue(forKey: self.edgeCount)
        self.bezierEdges.removeValue(forKey: self.edgeCount)
        self.quadEdges.removeValue(forKey: self.edgeCount)
        self.arcEdges.removeValue(forKey: self.edgeCount)
    }
    
    // MARK: - Core Graphics
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        for edge in self.assortedArcEdges {
            path.addPath(edge.cgPath)
        }
        for edge in self.assortedQuadEdges {
            path.addPath(edge.cgPath)
        }
        for edge in self.assortedBezierEdges {
            path.addPath(edge.cgPath)
        }
        for edge in self.assortedLinearEdges {
            path.addPath(edge.cgPath)
        }
        return path
    }
    
}
