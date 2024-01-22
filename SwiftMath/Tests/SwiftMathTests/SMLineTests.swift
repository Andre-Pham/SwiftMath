//
//  SMLineTests.swift
//
//
//  Created by Andre Pham on 22/1/2024.
//

import XCTest
import SwiftMath

final class SMLineTests: XCTestCase {
    
    func testIntersectsPoint() throws {
        // Case 1: Point on a horizontal line
        let horizontalLine = SMLine(point: SMPoint(x: 0.0, y: 0.0), direction: SMPoint(x: 1.0, y: 0.0))
        XCTAssertTrue(horizontalLine.intersects(point: SMPoint(x: 5.0, y: 0.0)))
        // Case 2: Point on a vertical line
        let verticalLine = SMLine(point: SMPoint(x: 2.0, y: 3.0), direction: SMPoint(x: 2.0, y: 4.0))
        XCTAssertTrue(verticalLine.intersects(point: SMPoint(x: 2.0, y: -1.0)))
        // Case 3: Point on a diagonal line
        let diagonalLine = SMLine(point: SMPoint(x: 0.0, y: 0.0), direction: SMPoint(x: 1.0, y: 1.0))
        XCTAssertTrue(diagonalLine.intersects(point: SMPoint(x: 3.0, y: 3.0)))
        // Case 4: Point not on the line
        XCTAssertFalse(diagonalLine.intersects(point: SMPoint(x: 3.0, y: 4.0)))
    }
    
    func testIntersectionWithLineSegment() throws {
        // Case 1: Intersecting line and line segment
        let line1 = SMLine(point: SMPoint(x: 0.0, y: 0.0), direction: SMPoint(x: 1.0, y: 1.0))
        let lineSegment1 = SMLineSegment(origin: SMPoint(x: 0.0, y: 1.0), end: SMPoint(x: 1.0, y: 0.0))
        XCTAssertEqual(line1.intersection(with: lineSegment1), SMPoint(x: 0.5, y: 0.5))
        // Case 2: Parallel line and line segment with no intersection
        let line2 = SMLine(point: SMPoint(x: 0.0, y: 0.0), direction: SMPoint(x: 1.0, y: 0.0))
        let lineSegment2 = SMLineSegment(origin: SMPoint(x: 0.0, y: 1.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertNil(line2.intersection(with: lineSegment2))
        // Case 3: Line and vertical line segment intersecting
        let verticalLineSegment = SMLineSegment(origin: SMPoint(x: 2.0, y: 1.0), end: SMPoint(x: 2.0, y: 3.0))
        XCTAssertEqual(line2.intersection(with: verticalLineSegment), SMPoint(x: 2.0, y: 0.0))
        // Case 4: Line and horizontal line segment not intersecting
        let horizontalLineSegment = SMLineSegment(origin: SMPoint(x: 0.0, y: 2.0), end: SMPoint(x: 3.0, y: 2.0))
        XCTAssertNil(line2.intersection(with: horizontalLineSegment))
    }
    
    func testIntersectionWithOtherLine() throws {
        // Case 1: Intersecting lines
        let line1 = SMLine(point: SMPoint(x: 0, y: 0), direction: SMPoint(x: 1, y: 1))
        let line2 = SMLine(point: SMPoint(x: 0, y: 1), direction: SMPoint(x: 1, y: 0))
        let expectedIntersection1 = SMPoint(x: 0.5, y: 0.5)
        XCTAssertEqual(line1.intersection(with: line2), expectedIntersection1)
        // Case 2: Parallel lines (no intersection)
        let line3 = SMLine(point: SMPoint(x: 0, y: 0), direction: SMPoint(x: 1, y: 1))
        let line4 = SMLine(point: SMPoint(x: 0, y: 1), direction: SMPoint(x: 1, y: 2))
        XCTAssertNil(line3.intersection(with: line4))
        // Case 3: Coincident lines (infinite intersections)
        let line5 = SMLine(point: SMPoint(x: 0, y: 0), direction: SMPoint(x: 1, y: 1))
        let line6 = SMLine(point: SMPoint(x: 1, y: 1), direction: SMPoint(x: 2, y: 2))
        XCTAssertNil(line5.intersection(with: line6)) // Or handle differently for coincident lines
        // Case 4: Perpendicular lines
        let line7 = SMLine(point: SMPoint(x: 0, y: 0), direction: SMPoint(x: 1, y: 0))
        let line8 = SMLine(point: SMPoint(x: 1, y: 1), direction: SMPoint(x: 1, y: 2))
        let expectedIntersection2 = SMPoint(x: 1, y: 0)
        XCTAssertEqual(line7.intersection(with: line8), expectedIntersection2)
        // Case 5: One line is vertical, the other diagonal
        let line9 = SMLine(point: SMPoint(x: 2, y: 0), direction: SMPoint(x: 2, y: 1))
        let line10 = SMLine(point: SMPoint(x: 0, y: 0), direction: SMPoint(x: 1, y: 1))
        let expectedIntersection3 = SMPoint(x: 2, y: 2)
        XCTAssertEqual(line9.intersection(with: line10), expectedIntersection3)
    }

    func testEquality() throws {
        let line1 = SMLine(point: SMPoint(x: 0.0, y: 0.0), direction: SMPoint(x: 1.0, y: 1.0))
        let line2 = SMLine(point: SMPoint(x: 2.0, y: 2.0), direction: SMPoint(x: 3.0, y: 3.0))
        XCTAssertTrue(line1 == line2)
        
        let line3 = SMLine(point: SMPoint(x: 0.0, y: 0.0), direction: SMPoint(x: 1.0, y: 0.0))
        XCTAssertFalse(line1 == line3)
    }
    
}
