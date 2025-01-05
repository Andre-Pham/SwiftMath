//
//  SMRectTests.swift
//
//
//  Created by Andre Pham on 28/1/2024.
//

import XCTest
import SwiftMath

final class SMRectTests: XCTestCase {
    
    func testCGRect() throws {
        let rect1 = SMRect(minX: 5.0, minY: 5.0, maxX: 10.0, maxY: 10.0)
        let cgRect = rect1.cgRect
        XCTAssertEqual(rect1.minCorner.x, cgRect.origin.x)
        XCTAssertEqual(rect1.minCorner.y, cgRect.origin.y)
        XCTAssertEqual(rect1.width, cgRect.width)
        XCTAssertEqual(rect1.height, cgRect.height)
    }
    
    func testCenter() throws {
        let rect = SMRect(minX: 5.0, minY: 5.0, maxX: 10.0, maxY: 10.0)
        XCTAssertTrue(rect.center == SMPoint(x: 7.5, y: 7.5))
    }
    
    func testUnion() throws {
        var rect1 = SMRect(minX: 0.0, minY: 0.0, maxX: 10.0, maxY: 10.0)
        var rect2 = SMRect(minX: -10.0, minY: 0.0, maxX: 5.0, maxY: 5.0)
        XCTAssertEqual(rect1.union(rect2), SMRect(minX: -10.0, minY: 0.0, maxX: 10.0, maxY: 10.0))
        rect1 = SMRect(minCorner: SMPoint(), maxCorner: SMPoint(x: 1.0, y: 1.0))
        rect2 = SMRect(minCorner: SMPoint(x: 2.0, y: 0.0), maxCorner: SMPoint(x: 3.0, y: 1.0))
        XCTAssertEqual(rect1.union(rect2), SMRect(minX: 0.0, minY: 0.0, maxX: 3.0, maxY: 1.0))
    }
    
    func testIntersects() throws {
        let rect1 = SMRect(minX: 0.0, minY: 0.0, maxX: 10.0, maxY: 10.0)
        var rect2 = SMRect(minX: -10.0, minY: -10.0, maxX: 0.0, maxY: 0.0)
        // Case 1: Touching corners
        XCTAssertTrue(rect1.intersects(with: rect2))
        rect2 = SMRect(minX: -10.0, minY: 0.0, maxX: 0.0, maxY: 10.0)
        // Case 2: Overlapping lines
        XCTAssertFalse(rect1.intersects(with: rect2))
        rect2 = SMRect(minX: -10.0, minY: 0.0, maxX: -0.5, maxY: 10.0)
        // Case 3: No relation
        XCTAssertFalse(rect1.intersects(with: rect2))
        // Case 4: Intersecting
        rect2 = rect1
        rect2.translate(by: SMPoint(x: 4.0, y: 5.0))
        XCTAssertTrue(rect1.intersects(with: rect2))
        // Case 5: Enclosed
        rect2 = SMRect(minX: 1.0, minY: 1.0, maxX: 2.0, maxY: 2.0)
        XCTAssertFalse(rect1.intersects(with: rect2))
        // Case 6: Containing
        rect2 = SMRect(minX: 0.0, minY: 1.0, maxX: 2.0, maxY: 2.0)
        XCTAssertFalse(rect1.intersects(with: rect2))
    }

    func testRelates() throws {
        let rect1 = SMRect(minX: 0.0, minY: 0.0, maxX: 10.0, maxY: 10.0)
        var rect2 = SMRect(minX: -10.0, minY: -10.0, maxX: 0.0, maxY: 0.0)
        // Case 1: Touching corners
        XCTAssertTrue(rect1.relates(to: rect2))
        rect2 = SMRect(minX: -10.0, minY: 0.0, maxX: 0.0, maxY: 10.0)
        // Case 2: Overlapping lines
        XCTAssertTrue(rect1.relates(to: rect2))
        rect2 = SMRect(minX: -10.0, minY: 0.0, maxX: -0.5, maxY: 10.0)
        // Case 3: No relation
        XCTAssertFalse(rect1.relates(to: rect2))
        // Case 4: Intersecting
        rect2 = rect1 + SMPoint(x: 4.0, y: 5.0)
        XCTAssertTrue(rect1.relates(to: rect2))
        // Case 5: Enclosed
        rect2 = SMRect(minX: 1.0, minY: 1.0, maxX: 2.0, maxY: 2.0)
        XCTAssertTrue(rect1.relates(to: rect2))
        // Case 6: Containing
        rect2 = SMRect(minX: 0.0, minY: 1.0, maxX: 2.0, maxY: 2.0)
        XCTAssertTrue(rect1.relates(to: rect2))
    }
    
    func testExpansion() throws {
        var rect = SMRect(minX: 200, minY: 200, maxX: 400, maxY: 300)
        rect.expand(minX: 20, minY: 100, maxX: 10, maxY: 5)
        XCTAssertEqual(rect.minX, 200 - 20)
        XCTAssertEqual(rect.minY, 200 - 100)
        XCTAssertEqual(rect.maxX, 400 + 10)
        XCTAssertEqual(rect.maxY, 300 + 5)
    }
    
    func testSize() throws {
        let rect = SMRect(minX: 200, minY: 200, maxX: 400, maxY: 300)
        XCTAssertTrue(rect.size == SMSize(width: 200, height: 100))
    }

}
