//
//  SMCurvilinearEdges.swift
//
//
//  Created by Andre Pham on 29/2/2024.
//

import Foundation

open class SMCurvilinearEdges: SMClonable {
    
    // MARK: - Properties
    
    private var linearEdges = [Int: SMLineSegment]()
    private var bezierEdges = [Int: SMBezierCurve]()
    private var quadEdges = [Int: SMQuadCurve]()
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
    
    // MARK: - Constructors
    
    public init() { }
    
    public required init(_ original: SMCurvilinearEdges) {
        self.linearEdges = original.linearEdges.clone()
        self.bezierEdges = original.bezierEdges.clone()
        self.quadEdges = original.quadEdges.clone()
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
    
    public func removeEdge(at index: Int) {
        let linearRemoved = self.linearEdges.removeValue(forKey: index) != nil
        let bezierRemoved = self.bezierEdges.removeValue(forKey: index) != nil
        let quadRemoved = self.quadEdges.removeValue(forKey: index) != nil
        let edgeWasRemoved = linearRemoved || bezierRemoved || quadRemoved
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
        self.linearEdges.removeValue(forKey: self.edgeCount)
        self.bezierEdges.removeValue(forKey: self.edgeCount)
        self.quadEdges.removeValue(forKey: self.edgeCount)
    }
    
}
