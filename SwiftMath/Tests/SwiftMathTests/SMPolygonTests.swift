//
//  SMPolygonTests.swift
//  SwiftMath
//
//  Created by Andre Pham on 19/1/2024.
//

import XCTest
import SwiftMath

final class SMPolygonTests: XCTestCase {

    func testLineSegments() throws {
        // Test for an empty polygon
        var polygon = SMPolygon(orderedPoints: [])
        XCTAssertTrue(polygon.lineSegments.isEmpty)
        // Test for a polygon with only one point (should not form any line segment)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 1.0, y: 1.0)])
        XCTAssertTrue(polygon.lineSegments.isEmpty)
        // Test for a polygon with two points
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 2.0)])
        XCTAssertEqual(polygon.lineSegments.count, 2)
        // Test for a triangle (three points, three line segments)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 2.0), SMPoint(x: 1.0, y: 2.0)])
        XCTAssertEqual(polygon.lineSegments.count, 3)
        // Test for a square (four points, four line segments)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 1.0), SMPoint(x: 2.0, y: 2.0), SMPoint(x: 1.0, y: 2.0)])
        XCTAssertEqual(polygon.lineSegments.count, 4)
        // Test that the first and last line segment are correct for a square
        let firstLine = polygon.lineSegments.first
        let lastLine = polygon.lineSegments.last
        XCTAssertEqual(firstLine, SMLineSegment(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 2.0, y: 1.0)))
        XCTAssertEqual(lastLine, SMLineSegment(origin: SMPoint(x: 1.0, y: 2.0), end: SMPoint(x: 1.0, y: 1.0)))
    }
    
    func testIsValid() throws {
        // Test for an empty polygon (invalid)
        var polygon = SMPolygon(orderedPoints: [])
        XCTAssertFalse(polygon.isValid)
        // Test for a polygon with only one point (invalid)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 1.0, y: 1.0)])
        XCTAssertFalse(polygon.isValid)
        // Test for a polygon with two points (invalid)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 2.0)])
        XCTAssertFalse(polygon.isValid)
        // Test for a valid triangle
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertTrue(polygon.isValid)
        // Test for a square (valid)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertTrue(polygon.isValid)
        // Test for a polygon with intersecting lines (invalid)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertFalse(polygon.isValid)
        // Test for a polygon with overlapping lines (invalid)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 0.5, y: 0.5), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 0.0, y: 0.0)])
        XCTAssertFalse(polygon.isValid)
    }
    
    func testArea() throws {
        // Test for an empty polygon (invalid, hence area should be nil)
        var polygon = SMPolygon(orderedPoints: [])
        XCTAssertNil(polygon.area)
        // Test for a polygon with only two points (invalid, hence area should be nil)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0)])
        XCTAssertNil(polygon.area)
        // Test for a valid triangle (area should be non-nil and correct)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertEqual(polygon.area, 0.5)
        // Test for a square (area should be non-nil and correct)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertEqual(polygon.area, 1.0)
        // Test for a complex polygon (valid, area should be non-nil and correct)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 0.5, y: 1.5), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertEqual(polygon.area, 1.25)
        // Test for a polygon with intersecting lines (invalid, hence area should be nil)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertNil(polygon.area)
    }

    func testPerimeter() throws {
        // Test for an empty polygon (invalid, hence perimeter should be nil)
        var polygon = SMPolygon(orderedPoints: [])
        XCTAssertNil(polygon.perimeter)

        // Test for a polygon with only two points (invalid, hence perimeter should be nil)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0)])
        XCTAssertNil(polygon.perimeter)

        // Test for a valid triangle (perimeter should be non-nil and correct)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertEqual(polygon.perimeter, 3.414213562373095) // Sides are 1, √2, and √2

        // Test for a square (perimeter should be non-nil and correct)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertEqual(polygon.perimeter, 4.0)

        // Test for a complex polygon (valid, perimeter should be non-nil and correct)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 0.5, y: 1.5), SMPoint(x: 0.0, y: 1.0)])
        XCTAssert(SM.isEqual(polygon.perimeter!, 4.41421))

        // Test for a polygon with intersecting lines (invalid, hence perimeter should be nil)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertNil(polygon.perimeter)
    }
    
    func testContainsPoint() throws {
        // Test for an empty polygon (invalid, hence all points should be outside)
        var polygon = SMPolygon(orderedPoints: [])
        XCTAssertFalse(polygon.contains(point: SMPoint(x: 1.0, y: 1.0)))
        // Test for a triangle with a point inside
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 2.0, y: 0.0), SMPoint(x: 1.0, y: 2.0)])
        XCTAssertTrue(polygon.contains(point: SMPoint(x: 1.0, y: 1.0)))
        // Test for a triangle with a point outside
        XCTAssertFalse(polygon.contains(point: SMPoint(x: -1.0, y: -1.0)))
        // Test for a square with a point on the edge
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 2.0, y: 0.0), SMPoint(x: 2.0, y: 2.0), SMPoint(x: 0.0, y: 2.0)])
        XCTAssertTrue(polygon.contains(point: SMPoint(x: 1.0, y: 0.0)))
        // Test for a square with a point inside
        XCTAssertTrue(polygon.contains(point: SMPoint(x: 1.0, y: 1.0)))
        // Test for a square with a point outside
        XCTAssertFalse(polygon.contains(point: SMPoint(x: 3.0, y: 3.0)))
        // Test for a complex polygon with a point inside
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 1.0, y: 0.0), SMPoint(x: 10.0, y: -10.0), SMPoint(x: 14.0, y: 4.0), SMPoint(x: 4.0, y: 12.0), SMPoint(x: 0.0, y: 4.0)])
        XCTAssertTrue(polygon.contains(point: SMPoint(x: 2, y: 3)))
        // Test for a complex polygon with a point outside
        XCTAssertFalse(polygon.contains(point: SMPoint(x: 0.0, y: 5.0)))
        // Test for a polygon with intersecting lines (invalid, hence all points should be outside)
        polygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertFalse(polygon.contains(point: SMPoint(x: 0.5, y: 0.5)))
    }
    
    func testContainsPolygon() throws {
        // Case 1: A polygon entirely within another
        let outerPolygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 5.0, y: 0.0), SMPoint(x: 5.0, y: 5.0), SMPoint(x: 0.0, y: 5.0)])
        let innerPolygon = SMPolygon(orderedPoints: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 4.0, y: 1.0), SMPoint(x: 4.0, y: 4.0), SMPoint(x: 1.0, y: 4.0)])
        XCTAssertTrue(outerPolygon.contains(polygon: innerPolygon))
        // Case 2: A polygon partially overlapping another
        let partiallyOverlappingPolygon = SMPolygon(orderedPoints: [SMPoint(x: 3.0, y: 3.0), SMPoint(x: 6.0, y: 3.0), SMPoint(x: 6.0, y: 6.0), SMPoint(x: 3.0, y: 6.0)])
        XCTAssertFalse(outerPolygon.contains(polygon: partiallyOverlappingPolygon))
        // Case 3: A polygon completely outside another
        let outsidePolygon = SMPolygon(orderedPoints: [SMPoint(x: 6.0, y: 6.0), SMPoint(x: 7.0, y: 6.0), SMPoint(x: 7.0, y: 7.0), SMPoint(x: 6.0, y: 7.0)])
        XCTAssertFalse(outerPolygon.contains(polygon: outsidePolygon))
        // Case 4: Polygons with one inside the other, but sharing an edge
        let edgeSharingPolygon = SMPolygon(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 5.0, y: 0.0), SMPoint(x: 5.0, y: 5.0)])
        XCTAssertTrue(outerPolygon.contains(polygon: edgeSharingPolygon))
        // Case 5: Invalid polygon
        let invalidPolygon = SMPolygon(orderedPoints: [SMPoint(x: 1.0, y: 1.0)]) // Invalid as it's not a polygon
        XCTAssertTrue(outerPolygon.contains(polygon: invalidPolygon))
    }
    
    func testClockwise() throws {
        // Case 1: Clockwise polygon
        let clockwisePolygon = SMPolygon(orderedPoints: [
            SMPoint(x: 0, y: 0),
            SMPoint(x: 0, y: 1),
            SMPoint(x: 1, y: 1),
            SMPoint(x: 1, y: 0)
        ])
        XCTAssertTrue(clockwisePolygon.isClockwise)
        XCTAssertFalse(clockwisePolygon.isAnticlockwise)
        // Case 2: Anticlockwise polygon
        let anticlockwisePolygon = SMPolygon(orderedPoints: [
            SMPoint(x: 0, y: 0),
            SMPoint(x: 1, y: 0),
            SMPoint(x: 1, y: 1),
            SMPoint(x: 0, y: 1)
        ])
        XCTAssertFalse(anticlockwisePolygon.isClockwise)
        XCTAssertTrue(anticlockwisePolygon.isAnticlockwise)
        // Case 3: Not a valid polygon (e.g., a line)
        let invalidPolygon = SMPolygon(orderedPoints: [
            SMPoint(x: 0, y: 0),
            SMPoint(x: 1, y: 1)
        ])
        XCTAssertFalse(invalidPolygon.isClockwise)
        XCTAssertFalse(invalidPolygon.isAnticlockwise)
    }

}
