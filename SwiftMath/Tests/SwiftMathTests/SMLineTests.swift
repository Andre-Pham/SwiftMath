//
//  SMLineTests.swift
//  SwiftMath
//
//  Created by Andre Pham on 19/1/2024.
//

import XCTest
import SwiftMath

final class SMLineTests: XCTestCase {

    func testLength() throws {
        let line = SMLine(origin: SMPoint(x: 10.0, y: -2.0), end: SMPoint(x: 5.0, y: 2.0))
        XCTAssert(SM.isEqual(line.length, 6.40312))
        let noLine = SMLine(origin: SMPoint(), end: SMPoint())
        XCTAssert(SM.isZero(noLine.length))
    }
    
    func testGradient() throws {
        let line = SMLine(origin: SMPoint(x: 10.0, y: -2.0), end: SMPoint(x: 5.0, y: 2.0))
        XCTAssert(SM.isEqual(line.gradient ?? 0.0, -0.800))
        let noLine = SMLine(origin: SMPoint(), end: SMPoint())
        XCTAssert(noLine.gradient == nil)
    }
    
    func testMidPoint() throws {
        let line = SMLine(origin: SMPoint(x: 10.0, y: -2.0), end: SMPoint(x: 5.0, y: 2.0))
        XCTAssert(line.midPoint == SMPoint(x: 7.5, y: 0.0))
        let noLine = SMLine(origin: SMPoint(), end: SMPoint())
        XCTAssert(noLine.midPoint == SMPoint())
    }
    
    func testVertical() throws {
        let verticalLine = SMLine(origin: SMPoint(), end: SMPoint(x: 0.0, y: 1.0))
        let horizontalLine = SMLine(origin: SMPoint(), end: SMPoint(x: 1.0, y: 0.0))
        XCTAssertTrue(verticalLine.isVertical)
        XCTAssertFalse(horizontalLine.isVertical)
    }
    
    func testHorizontal() throws {
        let verticalLine = SMLine(origin: SMPoint(), end: SMPoint(x: 0.0, y: 1.0))
        let horizontalLine = SMLine(origin: SMPoint(), end: SMPoint(x: 1.0, y: 0.0))
        XCTAssertFalse(verticalLine.isHorizontal)
        XCTAssertTrue(horizontalLine.isHorizontal)
    }
    
    func testIsValid() throws {
        let invalid = SMLine(origin: SMPoint(), end: SMPoint())
        let valid = SMLine(origin: SMPoint(x: 10.0, y: -2.0), end: SMPoint(x: 5.0, y: 2.0))
        XCTAssert(!invalid.isValid)
        XCTAssert(valid.isValid)
    }
    
    func testIsParallel() throws {
        // Case 1: Two parallel horizontal lines
        let horizontalLine1 = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 0.0))
        let horizontalLine2 = SMLine(origin: SMPoint(x: 0.0, y: 1.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertTrue(horizontalLine1.isParallel(to: horizontalLine2))
        // Case 2: Two parallel vertical lines
        let verticalLine1 = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 0.0, y: 1.0))
        let verticalLine2 = SMLine(origin: SMPoint(x: 1.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertTrue(verticalLine1.isParallel(to: verticalLine2))
        // Case 3: Two parallel lines with same slope
        let line1 = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        let line2 = SMLine(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 2.0, y: 2.0))
        XCTAssertTrue(line1.isParallel(to: line2))
        // Case 4: Two non-parallel lines with different slopes
        let nonParallelLine1 = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        let nonParallelLine2 = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 3.0)) // Different slope
        XCTAssertFalse(nonParallelLine1.isParallel(to: nonParallelLine2))
        // Case 5: Line with itself should always be parallel
        let selfParallelLine = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertTrue(selfParallelLine.isParallel(to: selfParallelLine))
        // Case 6: One or both lines are points (zero length)
        let pointLine = SMLine(origin: SMPoint(), end: SMPoint())
        XCTAssertFalse(pointLine.isParallel(to: horizontalLine1))
        XCTAssertFalse(verticalLine1.isParallel(to: pointLine))
        XCTAssertFalse(pointLine.isParallel(to: pointLine))
        // Case 7: Extremely close but not quite parallel lines
        let almostParallelLine1 = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1000.0, y: 1000.0))
        let almostParallelLine2 = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1000.0, y: 1000.0001))
        XCTAssertFalse(almostParallelLine1.isParallel(to: almostParallelLine2))
    }

    func testOverlaps() throws {
        // Case 1: Two overlapping horizontal lines
        let horizontalLine1 = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 5.0, y: 0.0))
        let horizontalLine2 = SMLine(origin: SMPoint(x: 3.0, y: 0.0), end: SMPoint(x: 8.0, y: 0.0))
        XCTAssertTrue(horizontalLine1.overlaps(with: horizontalLine2))
        // Case 2: Two overlapping vertical lines
        let verticalLine1 = SMLine(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 1.0, y: 4.0))
        let verticalLine2 = SMLine(origin: SMPoint(x: 1.0, y: 3.0), end: SMPoint(x: 1.0, y: 5.0))
        XCTAssertTrue(verticalLine1.overlaps(with: verticalLine2))
        // Case 3: Two non-overlapping but parallel lines
        let parallelLine1 = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 2.0, y: 2.0))
        let parallelLine2 = SMLine(origin: SMPoint(x: 0.0, y: 3.0), end: SMPoint(x: 2.0, y: 5.0))
        XCTAssertFalse(parallelLine1.overlaps(with: parallelLine2))
        // Case 4: Two identical lines
        let line = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertTrue(line.overlaps(with: line))
        // Case 5: Two non-parallel lines
        let nonParallelLine1 = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        let nonParallelLine2 = SMLine(origin: SMPoint(x: 0.0, y: 1.0), end: SMPoint(x: 1.0, y: 2.0))
        XCTAssertFalse(nonParallelLine1.overlaps(with: nonParallelLine2))
        // Case 6: Overlapping lines where one line is a subset of the other
        let subsetLine1 = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 10.0, y: 0.0))
        let subsetLine2 = SMLine(origin: SMPoint(x: 3.0, y: 0.0), end: SMPoint(x: 7.0, y: 0.0))
        XCTAssertTrue(subsetLine1.overlaps(with: subsetLine2))
        // Case 7: Lines that share only a single endpoint
        let touchingLine1 = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        let touchingLine2 = SMLine(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 2.0, y: 2.0))
        XCTAssertFalse(touchingLine1.overlaps(with: touchingLine2))
        // Case 8: One or both lines are points (zero length)
        let pointLine = SMLine(origin: SMPoint(), end: SMPoint())
        XCTAssertFalse(pointLine.overlaps(with: horizontalLine1))
        XCTAssertFalse(verticalLine1.overlaps(with: pointLine))
        XCTAssertFalse(pointLine.overlaps(with: pointLine))
    }
    
    func testIntersectsPoint() throws {
        // Case 1: Point lies on a horizontal line
        let horizontalLine = SMLine(origin: SMPoint(x: 0.0, y: 1.0), end: SMPoint(x: 5.0, y: 1.0))
        let pointOnLine1 = SMPoint(x: 3.0, y: 1.0)
        XCTAssertTrue(horizontalLine.intersects(point: pointOnLine1))
        // Case 2: Point lies on a vertical line
        let verticalLine = SMLine(origin: SMPoint(x: 2.0, y: 0.0), end: SMPoint(x: 2.0, y: 5.0))
        let pointOnLine2 = SMPoint(x: 2.0, y: 3.0)
        XCTAssertTrue(verticalLine.intersects(point: pointOnLine2))
        // Case 3: Point lies on a diagonal line
        let diagonalLine = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 5.0, y: 5.0))
        let pointOnLine3 = SMPoint(x: 2.5, y: 2.5)
        XCTAssertTrue(diagonalLine.intersects(point: pointOnLine3))
        // Case 4: Point does not lie on the line
        let pointNotOnLine = SMPoint(x: 1.0, y: 2.0)
        XCTAssertFalse(diagonalLine.intersects(point: pointNotOnLine))
        // Case 5: Point is one of the endpoints of the line
        XCTAssertTrue(diagonalLine.intersects(point: diagonalLine.origin))
        XCTAssertTrue(diagonalLine.intersects(point: diagonalLine.end))
        // Case 6: Line is a point (zero length), and the point is the same as the line
        let pointLine = SMLine(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertTrue(pointLine.intersects(point: SMPoint(x: 1.0, y: 1.0)))
        // Case 7: Line is a point (zero length), and the point is different
        XCTAssertFalse(pointLine.intersects(point: SMPoint(x: 2.0, y: 2.0)))
        // Case 8: Point lies on the line extension but not on the line segment
        let pointOnExtension = SMPoint(x: -1.0, y: -1.0)
        XCTAssertFalse(diagonalLine.intersects(point: pointOnExtension))
    }
    
    func testIntersectionWithLine() throws {
        // Case 1: Intersecting lines
        let line1 = SMLine(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 4, y: 4))
        let line2 = SMLine(origin: SMPoint(x: 0, y: 4), end: SMPoint(x: 4, y: 0))
        let expectedIntersection1 = SMPoint(x: 2, y: 2)
        XCTAssertEqual(line1.intersection(with: line2), expectedIntersection1)
        // Case 2: Parallel lines (no intersection)
        let parallelLine1 = SMLine(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 4, y: 4))
        let parallelLine2 = SMLine(origin: SMPoint(x: 0, y: 1), end: SMPoint(x: 4, y: 5))
        XCTAssertNil(parallelLine1.intersection(with: parallelLine2))
        // Case 3: Coincident lines (overlapping)
        let coincidentLine1 = SMLine(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 4, y: 4))
        let coincidentLine2 = SMLine(origin: SMPoint(x: 1, y: 1), end: SMPoint(x: 3, y: 3))
        XCTAssertNil(coincidentLine1.intersection(with: coincidentLine2))
        // Case 4: Non-intersecting lines
        let nonIntersectingLine1 = SMLine(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 2, y: 2))
        let nonIntersectingLine2 = SMLine(origin: SMPoint(x: 3, y: 3), end: SMPoint(x: 5, y: 3))
        XCTAssertNil(nonIntersectingLine1.intersection(with: nonIntersectingLine2))
        // Case 5: Intersecting at endpoints
        let endpointLine1 = SMLine(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 2, y: 2))
        let endpointLine2 = SMLine(origin: SMPoint(x: 2, y: 2), end: SMPoint(x: 4, y: 4))
        let expectedIntersection2 = SMPoint(x: 2, y: 2)
        XCTAssertEqual(endpointLine1.intersection(with: endpointLine2), expectedIntersection2)
        // Case 6: Lines are points (zero length), intersecting
        let pointLine1 = SMLine(origin: SMPoint(x: 1, y: 1), end: SMPoint(x: 1, y: 1))
        let pointLine2 = SMLine(origin: SMPoint(x: 1, y: 1), end: SMPoint(x: 1, y: 1))
        let expectedIntersection3 = SMPoint(x: 1, y: 1)
        XCTAssertEqual(pointLine1.intersection(with: pointLine2), expectedIntersection3)
        // Case 7: Lines are points (zero length), not intersecting
        let pointLine3 = SMLine(origin: SMPoint(x: 1, y: 1), end: SMPoint(x: 1, y: 1))
        let pointLine4 = SMLine(origin: SMPoint(x: 2, y: 2), end: SMPoint(x: 2, y: 2))
        XCTAssertNil(pointLine3.intersection(with: pointLine4))
    }
    
    func testTouchingPointWithLine() throws {
        // Case 1: Lines touch at their origins
        let line1 = SMLine(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 2.0, y: 2.0))
        let line2 = SMLine(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 0.0, y: 0.0))
        let expectedTouch1 = SMPoint(x: 1.0, y: 1.0)
        XCTAssertEqual(line1.touchingPoint(with: line2), expectedTouch1)
        // Case 2: Lines touch at their ends
        let line3 = SMLine(origin: SMPoint(x: 2.0, y: 2.0), end: SMPoint(x: 3.0, y: 3.0))
        let expectedTouch2 = SMPoint(x: 2.0, y: 2.0)
        XCTAssertEqual(line1.touchingPoint(with: line3), expectedTouch2)
        // Case 3: Lines do not touch
        let line4 = SMLine(origin: SMPoint(x: 3.0, y: 3.0), end: SMPoint(x: 4.0, y: 4.0))
        XCTAssertNil(line1.touchingPoint(with: line4))
        // Case 4: Lines overlap completely
        let line5 = SMLine(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 2.0, y: 2.0))
        XCTAssertNil(line1.touchingPoint(with: line5))
        // Case 5: Lines touch at one line's end and the other's origin
        let line6 = SMLine(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(line1.touchingPoint(with: line6), expectedTouch1)
        // Case 6: One of the lines is a point (zero length)
        let pointLine = SMLine(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(pointLine.touchingPoint(with: line1), expectedTouch1)
        XCTAssertNil(pointLine.touchingPoint(with: line4))
        // Case 7: Lines touch at one point but also overlap partially (not completely)
        let overlappingLine = SMLine(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 1.5, y: 1.5))
        XCTAssertNil(line1.touchingPoint(with: overlappingLine))
    }

}
