//
//  SMLineSegmentTests.swift
//  SwiftMath
//
//  Created by Andre Pham on 19/1/2024.
//

import XCTest
@testable import SwiftMath

final class SMLineSegmentTests: XCTestCase {

    func testLength() throws {
        let line = SMLineSegment(origin: SMPoint(x: 10.0, y: -2.0), end: SMPoint(x: 5.0, y: 2.0))
        XCTAssert(line.length.isEqual(to: 6.40312))
        let noLine = SMLineSegment(origin: SMPoint(), end: SMPoint())
        XCTAssert(noLine.length.isZero())
    }
    
    func testGradient() throws {
        let line = SMLineSegment(origin: SMPoint(x: 10.0, y: -2.0), end: SMPoint(x: 5.0, y: 2.0))
        XCTAssert((line.gradient ?? 0.0).isEqual(to: -0.800))
        let noLine = SMLineSegment(origin: SMPoint(), end: SMPoint())
        XCTAssert(noLine.gradient == nil)
    }
    
    func testMidPoint() throws {
        let line = SMLineSegment(origin: SMPoint(x: 10.0, y: -2.0), end: SMPoint(x: 5.0, y: 2.0))
        XCTAssert(line.midPoint == SMPoint(x: 7.5, y: 0.0))
        let noLine = SMLineSegment(origin: SMPoint(), end: SMPoint())
        XCTAssert(noLine.midPoint == SMPoint())
    }
    
    func testVertical() throws {
        let verticalLine = SMLineSegment(origin: SMPoint(), end: SMPoint(x: 0.0, y: 1.0))
        let horizontalLine = SMLineSegment(origin: SMPoint(), end: SMPoint(x: 1.0, y: 0.0))
        XCTAssertTrue(verticalLine.isVertical)
        XCTAssertFalse(horizontalLine.isVertical)
    }
    
    func testHorizontal() throws {
        let verticalLine = SMLineSegment(origin: SMPoint(), end: SMPoint(x: 0.0, y: 1.0))
        let horizontalLine = SMLineSegment(origin: SMPoint(), end: SMPoint(x: 1.0, y: 0.0))
        XCTAssertFalse(verticalLine.isHorizontal)
        XCTAssertTrue(horizontalLine.isHorizontal)
    }
    
    func testIsValid() throws {
        let invalid = SMLineSegment(origin: SMPoint(), end: SMPoint())
        let valid = SMLineSegment(origin: SMPoint(x: 10.0, y: -2.0), end: SMPoint(x: 5.0, y: 2.0))
        XCTAssert(!invalid.isValid)
        XCTAssert(valid.isValid)
    }
    
    func testIsParallel() throws {
        // Case 1: Two parallel horizontal lines
        let horizontalLine1 = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 0.0))
        let horizontalLine2 = SMLineSegment(origin: SMPoint(x: 0.0, y: 1.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertTrue(horizontalLine1.isParallel(to: horizontalLine2))
        // Case 2: Two parallel vertical lines
        let verticalLine1 = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 0.0, y: 1.0))
        let verticalLine2 = SMLineSegment(origin: SMPoint(x: 1.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertTrue(verticalLine1.isParallel(to: verticalLine2))
        // Case 3: Two parallel lines with same slope
        let line1 = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        let line2 = SMLineSegment(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 2.0, y: 2.0))
        XCTAssertTrue(line1.isParallel(to: line2))
        // Case 4: Two non-parallel lines with different slopes
        let nonParallelLine1 = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        let nonParallelLine2 = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 3.0)) // Different slope
        XCTAssertFalse(nonParallelLine1.isParallel(to: nonParallelLine2))
        // Case 5: Line with itself should always be parallel
        let selfParallelLine = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertTrue(selfParallelLine.isParallel(to: selfParallelLine))
        // Case 6: One or both lines are points (zero length)
        let pointLine = SMLineSegment(origin: SMPoint(), end: SMPoint())
        XCTAssertFalse(pointLine.isParallel(to: horizontalLine1))
        XCTAssertFalse(verticalLine1.isParallel(to: pointLine))
        XCTAssertFalse(pointLine.isParallel(to: pointLine))
        // Case 7: Extremely close but not quite parallel lines
        let almostParallelLine1 = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1000.0, y: 1000.0))
        let almostParallelLine2 = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1000.0, y: 1000.1))
        XCTAssertFalse(almostParallelLine1.isParallel(to: almostParallelLine2))
    }

    func testOverlaps() throws {
        // Case 1: Two overlapping horizontal lines
        let horizontalLine1 = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 5.0, y: 0.0))
        let horizontalLine2 = SMLineSegment(origin: SMPoint(x: 3.0, y: 0.0), end: SMPoint(x: 8.0, y: 0.0))
        XCTAssertTrue(horizontalLine1.overlaps(with: horizontalLine2))
        // Case 2: Two overlapping vertical lines
        let verticalLine1 = SMLineSegment(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 1.0, y: 4.0))
        let verticalLine2 = SMLineSegment(origin: SMPoint(x: 1.0, y: 3.0), end: SMPoint(x: 1.0, y: 5.0))
        XCTAssertTrue(verticalLine1.overlaps(with: verticalLine2))
        // Case 3: Two non-overlapping but parallel lines
        let parallelLine1 = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 2.0, y: 2.0))
        let parallelLine2 = SMLineSegment(origin: SMPoint(x: 0.0, y: 3.0), end: SMPoint(x: 2.0, y: 5.0))
        XCTAssertFalse(parallelLine1.overlaps(with: parallelLine2))
        // Case 4: Two identical lines
        let line = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertTrue(line.overlaps(with: line))
        // Case 5: Two non-parallel lines
        let nonParallelLine1 = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        let nonParallelLine2 = SMLineSegment(origin: SMPoint(x: 0.0, y: 1.0), end: SMPoint(x: 1.0, y: 2.0))
        XCTAssertFalse(nonParallelLine1.overlaps(with: nonParallelLine2))
        // Case 6: Overlapping lines where one line is a subset of the other
        let subsetLine1 = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 10.0, y: 0.0))
        let subsetLine2 = SMLineSegment(origin: SMPoint(x: 3.0, y: 0.0), end: SMPoint(x: 7.0, y: 0.0))
        XCTAssertTrue(subsetLine1.overlaps(with: subsetLine2))
        // Case 7: Lines that share only a single endpoint
        let touchingLine1 = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        let touchingLine2 = SMLineSegment(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 2.0, y: 2.0))
        XCTAssertFalse(touchingLine1.overlaps(with: touchingLine2))
        // Case 8: One or both lines are points (zero length)
        let pointLine = SMLineSegment(origin: SMPoint(), end: SMPoint())
        XCTAssertFalse(pointLine.overlaps(with: horizontalLine1))
        XCTAssertFalse(verticalLine1.overlaps(with: pointLine))
        XCTAssertFalse(pointLine.overlaps(with: pointLine))
    }
    
    func testIntersectsPoint() throws {
        // Case 1: Point lies on a horizontal line
        let horizontalLine = SMLineSegment(origin: SMPoint(x: 0.0, y: 1.0), end: SMPoint(x: 5.0, y: 1.0))
        let pointOnLine1 = SMPoint(x: 3.0, y: 1.0)
        XCTAssertTrue(horizontalLine.intersects(point: pointOnLine1))
        // Case 2: Point lies on a vertical line
        let verticalLine = SMLineSegment(origin: SMPoint(x: 2.0, y: 0.0), end: SMPoint(x: 2.0, y: 5.0))
        let pointOnLine2 = SMPoint(x: 2.0, y: 3.0)
        XCTAssertTrue(verticalLine.intersects(point: pointOnLine2))
        // Case 3: Point lies on a diagonal line
        let diagonalLine = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 5.0, y: 5.0))
        let pointOnLine3 = SMPoint(x: 2.5, y: 2.5)
        XCTAssertTrue(diagonalLine.intersects(point: pointOnLine3))
        // Case 4: Point does not lie on the line
        let pointNotOnLine = SMPoint(x: 1.0, y: 2.0)
        XCTAssertFalse(diagonalLine.intersects(point: pointNotOnLine))
        // Case 5: Point is one of the endpoints of the line
        XCTAssertTrue(diagonalLine.intersects(point: diagonalLine.origin))
        XCTAssertTrue(diagonalLine.intersects(point: diagonalLine.end))
        // Case 6: Line is a point (zero length), and the point is the same as the line
        let pointLine = SMLineSegment(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertTrue(pointLine.intersects(point: SMPoint(x: 1.0, y: 1.0)))
        // Case 7: Line is a point (zero length), and the point is different
        XCTAssertFalse(pointLine.intersects(point: SMPoint(x: 2.0, y: 2.0)))
        // Case 8: Point lies on the line extension but not on the line segment
        let pointOnExtension = SMPoint(x: -1.0, y: -1.0)
        XCTAssertFalse(diagonalLine.intersects(point: pointOnExtension))
    }
    
    func testIntersectionWithLine() throws {
        // Case 1: Intersecting lines
        let line1 = SMLineSegment(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 4, y: 4))
        let line2 = SMLineSegment(origin: SMPoint(x: 0, y: 4), end: SMPoint(x: 4, y: 0))
        let expectedIntersection1 = SMPoint(x: 2, y: 2)
        XCTAssertEqual(line1.intersection(with: line2), expectedIntersection1)
        // Case 2: Parallel lines (no intersection)
        let parallelLine1 = SMLineSegment(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 4, y: 4))
        let parallelLine2 = SMLineSegment(origin: SMPoint(x: 0, y: 1), end: SMPoint(x: 4, y: 5))
        XCTAssertNil(parallelLine1.intersection(with: parallelLine2))
        // Case 3: Coincident lines (overlapping)
        let coincidentLine1 = SMLineSegment(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 4, y: 4))
        let coincidentLine2 = SMLineSegment(origin: SMPoint(x: 1, y: 1), end: SMPoint(x: 3, y: 3))
        XCTAssertNil(coincidentLine1.intersection(with: coincidentLine2))
        // Case 4: Non-intersecting lines
        let nonIntersectingLine1 = SMLineSegment(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 2, y: 2))
        let nonIntersectingLine2 = SMLineSegment(origin: SMPoint(x: 3, y: 3), end: SMPoint(x: 5, y: 3))
        XCTAssertNil(nonIntersectingLine1.intersection(with: nonIntersectingLine2))
        // Case 5: Intersecting at endpoints
        let endpointLine1 = SMLineSegment(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 2, y: 2))
        let endpointLine2 = SMLineSegment(origin: SMPoint(x: 2, y: 2), end: SMPoint(x: 4, y: 4))
        let expectedIntersection2 = SMPoint(x: 2, y: 2)
        XCTAssertEqual(endpointLine1.intersection(with: endpointLine2), expectedIntersection2)
        // Case 6: Lines are points (zero length), intersecting
        let pointLine1 = SMLineSegment(origin: SMPoint(x: 1, y: 1), end: SMPoint(x: 1, y: 1))
        let pointLine2 = SMLineSegment(origin: SMPoint(x: 1, y: 1), end: SMPoint(x: 1, y: 1))
        let expectedIntersection3 = SMPoint(x: 1, y: 1)
        XCTAssertEqual(pointLine1.intersection(with: pointLine2), expectedIntersection3)
        // Case 7: Lines are points (zero length), not intersecting
        let pointLine3 = SMLineSegment(origin: SMPoint(x: 1, y: 1), end: SMPoint(x: 1, y: 1))
        let pointLine4 = SMLineSegment(origin: SMPoint(x: 2, y: 2), end: SMPoint(x: 2, y: 2))
        XCTAssertNil(pointLine3.intersection(with: pointLine4))
        let line3 = SMLineSegment(origin: SMPoint(x: -10, y: 0), end: SMPoint(x: 10, y: 0))
        let line4 = SMLineSegment(origin: SMPoint(x: 10, y: 10), end: SMPoint(x: 0, y: 5))
        XCTAssertFalse(line3.intersects(line: line4))
    }
    
    func testTouchingPointWithLine() throws {
        // Case 1: Lines touch at their origins
        let line1 = SMLineSegment(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 2.0, y: 2.0))
        let line2 = SMLineSegment(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 0.0, y: 0.0))
        let expectedTouch1 = SMPoint(x: 1.0, y: 1.0)
        XCTAssertEqual(line1.touchingPoint(with: line2), expectedTouch1)
        // Case 2: Lines touch at their ends
        let line3 = SMLineSegment(origin: SMPoint(x: 2.0, y: 2.0), end: SMPoint(x: 3.0, y: 3.0))
        let expectedTouch2 = SMPoint(x: 2.0, y: 2.0)
        XCTAssertEqual(line1.touchingPoint(with: line3), expectedTouch2)
        // Case 3: Lines do not touch
        let line4 = SMLineSegment(origin: SMPoint(x: 3.0, y: 3.0), end: SMPoint(x: 4.0, y: 4.0))
        XCTAssertNil(line1.touchingPoint(with: line4))
        // Case 4: Lines overlap completely
        let line5 = SMLineSegment(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 2.0, y: 2.0))
        XCTAssertNil(line1.touchingPoint(with: line5))
        // Case 5: Lines touch at one line's end and the other's origin
        let line6 = SMLineSegment(origin: SMPoint(x: 0.0, y: 0.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(line1.touchingPoint(with: line6), expectedTouch1)
        // Case 6: One of the lines is a point (zero length)
        let pointLine = SMLineSegment(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 1.0, y: 1.0))
        XCTAssertEqual(pointLine.touchingPoint(with: line1), expectedTouch1)
        XCTAssertNil(pointLine.touchingPoint(with: line4))
        // Case 7: Lines touch at one point but also overlap partially (not completely)
        let overlappingLine = SMLineSegment(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 1.5, y: 1.5))
        XCTAssertNil(line1.touchingPoint(with: overlappingLine))
    }
    
    func testAngleInit() throws {
        let line = SMLineSegment(origin: SMPoint(x: 1.0, y: 1.0), angle: SMAngle(degrees: 180), length: 10.0)
        XCTAssertEqual(line.origin, SMPoint(x: 1, y: 1))
        dump(line.end)
        XCTAssertEqual(line.end, SMPoint(x: -9, y: 1))
    }
    
    func testCollinearLineSegments() throws {
        // Case 1: Two identical line segments
        let line1 = SMLineSegment(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 10, y: 10))
        let line2 = SMLineSegment(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 10, y: 10))
        XCTAssertTrue(line1.isCollinear(with: line2))
        // Case 2: Two line segments on the same line but not overlapping
        let line3 = SMLineSegment(origin: SMPoint(x: -10, y: -10), end: SMPoint(x: -5, y: -5))
        XCTAssertTrue(line1.isCollinear(with: line3))
        // Case 3: Two perpendicular line segments
        let line4 = SMLineSegment(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 0, y: 10))
        XCTAssertFalse(line1.isCollinear(with: line4))
        // Case 4: Two parallel but not collinear line segments
        let line5 = SMLineSegment(origin: SMPoint(x: 0, y: 1), end: SMPoint(x: 10, y: 11))
        XCTAssertFalse(line1.isCollinear(with: line5))
        // Case 5: Collinear but one line segment is a point
        let pointLine = SMLineSegment(origin: SMPoint(x: 5, y: 5), end: SMPoint(x: 5, y: 5))
        XCTAssertTrue(line1.isCollinear(with: pointLine))
        // Case 6: Non-collinear, intersecting line segments
        let line6 = SMLineSegment(origin: SMPoint(x: -10, y: 10), end: SMPoint(x: 10, y: -10))
        XCTAssertFalse(line1.isCollinear(with: line6))
    }
    
    func testCollinearLine() throws {
        // Case 1: Line segment and line are collinear
        let lineSegment1 = SMLineSegment(origin: SMPoint(x: 0, y: 0), end: SMPoint(x: 5, y: 5))
        let line1 = SMLine(point: SMPoint(x: -5, y: -5), direction: SMPoint(x: 10, y: 10))
        XCTAssertTrue(lineSegment1.isCollinear(with: line1))
        // Case 2: Line segment and line are parallel but not collinear
        let line2 = SMLine(point: SMPoint(x: 0, y: 1), direction: SMPoint(x: 5, y: 6))
        XCTAssertFalse(lineSegment1.isCollinear(with: line2))
        // Case 3: Line segment and line are perpendicular
        let line3 = SMLine(point: SMPoint(x: 0, y: 0), direction: SMPoint(x: 0, y: 5))
        XCTAssertFalse(lineSegment1.isCollinear(with: line3))
        // Case 4: Line segment is a point, and point lies on the line
        let pointSegment = SMLineSegment(origin: SMPoint(x: 2, y: 2), end: SMPoint(x: 2, y: 2))
        XCTAssertTrue(pointSegment.isCollinear(with: line1))
        // Case 5: Line segment is a point, and point does not lie on the line
        XCTAssertFalse(pointSegment.isCollinear(with: line3))
    }
    
    func testAdjustLength() throws {
        // Case 1: Regular line extended positive
        var line = SMLineSegment(origin: SMPoint(x: 2, y: 5), end: SMPoint(x: 3, y: 7))
        var length = line.length
        line.adjustLength(by: 10.0)
        XCTAssertTrue(line.length.isEqual(to: length + 10.0))
        XCTAssertTrue(line.origin == SMPoint(x: 2, y: 5))
        // Case 2: Regular line extended negative
        line = SMLineSegment(origin: SMPoint(x: 2, y: 5), end: SMPoint(x: 3, y: 7))
        length = line.length
        line.adjustLength(by: -1.0)
        XCTAssertTrue(line.length.isEqual(to: length - 1.0))
        XCTAssertTrue(line.origin == SMPoint(x: 2, y: 5))
        // Case 3: Backwards line extended positive
        line = SMLineSegment(origin: SMPoint(x: 3, y: 7), end: SMPoint(x: 2, y: 5))
        length = line.length
        line.adjustLength(by: 10.0)
        XCTAssertTrue(line.length.isEqual(to: length + 10.0))
        XCTAssertTrue(line.origin == SMPoint(x: 3, y: 7))
        // Case 4: Backwards line extended negative
        line = SMLineSegment(origin: SMPoint(x: 3, y: 7), end: SMPoint(x: 2, y: 5))
        length = line.length
        line.adjustLength(by: -1.0)
        XCTAssertTrue(line.length.isEqual(to: length - 1.0))
        XCTAssertTrue(line.origin == SMPoint(x: 3, y: 7))
        // Case 5: Invalid line
        line = SMLineSegment(origin: SMPoint(), end: SMPoint())
        line.adjustLength(by: 1.0)
        XCTAssertTrue(line.length.isEqual(to: 0.0))
        XCTAssertTrue(line.origin == SMPoint())
        // Case 6: adjusted length > line.length
        line = SMLineSegment(origin: SMPoint(x: 2, y: 5), end: SMPoint(x: 3, y: 7))
        length = line.length
        line.adjustLength(by: -(length + 5.0))
        XCTAssertTrue(line.length.isEqual(to: 5.0))
        XCTAssertTrue(line.origin == SMPoint(x: 2, y: 5))
    }
    
    func testSetLength() throws {
        // Case 1: Regular line set to a longer length
        var line = SMLineSegment(origin: SMPoint(x: 1, y: 2), end: SMPoint(x: 4, y: 6))
        var newLength = 10.0
        line.setLength(to: newLength)
        XCTAssertTrue(line.length.isEqual(to: newLength))
        XCTAssertTrue(line.origin == SMPoint(x: 1, y: 2))
        // Case 2: Regular line set to a shorter length
        line = SMLineSegment(origin: SMPoint(x: 1, y: 2), end: SMPoint(x: 4, y: 6))
        newLength = 3.0
        line.setLength(to: newLength)
        XCTAssertTrue(line.length.isEqual(to: newLength))
        XCTAssertTrue(line.origin == SMPoint(x: 1, y: 2))
        // Case 3: Line set to a negative length (should extend in opposite direction)
        line = SMLineSegment(origin: SMPoint(x: 1, y: 2), end: SMPoint(x: 4, y: 6))
        newLength = -5.0
        line.setLength(to: newLength)
        XCTAssertTrue(line.length.isEqual(to: 5.0)) // Length is positive even if set to negative
        XCTAssertTrue(line.origin == SMPoint(x: 1, y: 2))
        // Case 4: Invalid line (zero length)
        line = SMLineSegment(origin: SMPoint(), end: SMPoint())
        newLength = 10.0
        line.setLength(to: newLength)
        XCTAssertTrue(line.length.isEqual(to: 0.0)) // Length remains 0 as line is invalid
        XCTAssertTrue(line.origin == SMPoint())
        // Case 5: Setting length to zero
        line = SMLineSegment(origin: SMPoint(x: 1, y: 2), end: SMPoint(x: 4, y: 6))
        newLength = 0.0
        line.setLength(to: newLength)
        XCTAssertTrue(line.length.isEqual(to: 0.0))
        XCTAssertTrue(line.origin == SMPoint(x: 1, y: 2))
    }

}
