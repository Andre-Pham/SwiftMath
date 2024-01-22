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
        XCTAssertEqual(firstLine, SMLine(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 2.0, y: 1.0)))
        XCTAssertEqual(lastLine, SMLine(origin: SMPoint(x: 1.0, y: 2.0), end: SMPoint(x: 1.0, y: 1.0)))
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

}
