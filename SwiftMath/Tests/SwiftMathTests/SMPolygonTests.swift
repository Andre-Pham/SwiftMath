//
//  SMPolygonTests.swift
//  SwiftMath
//
//  Created by Andre Pham on 19/1/2024.
//

import XCTest
import SwiftMath

final class SMPolygonTests: XCTestCase {

    func testEdges() throws {
        // Test for an empty polygon
        var polygon = SMPolygon(vertices: [])
        XCTAssertTrue(polygon.edges.isEmpty)
        // Test for a polygon with only one point (should not form any line segment)
        polygon = SMPolygon(vertices: [SMPoint(x: 1.0, y: 1.0)])
        XCTAssertTrue(polygon.edges.isEmpty)
        // Test for a polygon with two points
        polygon = SMPolygon(vertices: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 2.0)])
        XCTAssertEqual(polygon.edges.count, 2)
        // Test for a triangle (three points, three line segments)
        polygon = SMPolygon(vertices: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 2.0), SMPoint(x: 1.0, y: 2.0)])
        XCTAssertEqual(polygon.edges.count, 3)
        // Test for a square (four points, four line segments)
        polygon = SMPolygon(vertices: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 1.0), SMPoint(x: 2.0, y: 2.0), SMPoint(x: 1.0, y: 2.0)])
        XCTAssertEqual(polygon.edges.count, 4)
        // Test that the first and last line segment are correct for a square
        let firstEdge = polygon.edges.first
        let lastEdge = polygon.edges.last
        XCTAssertEqual(firstEdge, SMLineSegment(origin: SMPoint(x: 1.0, y: 1.0), end: SMPoint(x: 2.0, y: 1.0)))
        XCTAssertEqual(lastEdge, SMLineSegment(origin: SMPoint(x: 1.0, y: 2.0), end: SMPoint(x: 1.0, y: 1.0)))
    }
    
    func testIsValid() throws {
        // Test for an empty polygon (invalid)
        var polygon = SMPolygon(vertices: [])
        XCTAssertFalse(polygon.isValid)
        // Test for a polygon with only one point (invalid)
        polygon = SMPolygon(vertices: [SMPoint(x: 1.0, y: 1.0)])
        XCTAssertFalse(polygon.isValid)
        // Test for a polygon with two points (invalid)
        polygon = SMPolygon(vertices: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 2.0)])
        XCTAssertFalse(polygon.isValid)
        // Test for a valid triangle
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertTrue(polygon.isValid)
        // Test for a square (valid)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertTrue(polygon.isValid)
        // Test for a polygon with intersecting lines (invalid)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertFalse(polygon.isValid)
        // Test for a polygon with overlapping lines (invalid)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 0.5, y: 0.5), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 0.0, y: 0.0)])
        XCTAssertFalse(polygon.isValid)
    }
    
    func testArea() throws {
        // Test for an empty polygon (invalid, hence area should be nil)
        var polygon = SMPolygon(vertices: [])
        XCTAssertNil(polygon.area)
        // Test for a polygon with only two points (invalid, hence area should be nil)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0)])
        XCTAssertNil(polygon.area)
        // Test for a valid triangle (area should be non-nil and correct)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertEqual(polygon.area, 0.5)
        // Test for a square (area should be non-nil and correct)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertEqual(polygon.area, 1.0)
        // Test for a complex polygon (valid, area should be non-nil and correct)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 0.5, y: 1.5), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertEqual(polygon.area, 1.25)
        // Test for a polygon with intersecting lines (invalid, hence area should be nil)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertNil(polygon.area)
    }

    func testPerimeter() throws {
        // Test for an empty polygon (invalid, hence perimeter should be nil)
        var polygon = SMPolygon(vertices: [])
        XCTAssertNil(polygon.perimeter)

        // Test for a polygon with only two points (invalid, hence perimeter should be nil)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0)])
        XCTAssertNil(polygon.perimeter)

        // Test for a valid triangle (perimeter should be non-nil and correct)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertEqual(polygon.perimeter, 3.414213562373095) // Sides are 1, √2, and √2

        // Test for a square (perimeter should be non-nil and correct)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertEqual(polygon.perimeter, 4.0)

        // Test for a complex polygon (valid, perimeter should be non-nil and correct)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 0.5, y: 1.5), SMPoint(x: 0.0, y: 1.0)])
        XCTAssert(SM.isEqual(polygon.perimeter!, 4.41421))

        // Test for a polygon with intersecting lines (invalid, hence perimeter should be nil)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertNil(polygon.perimeter)
    }
    
    func testContainsPoint() throws {
        // Test for an empty polygon (invalid, hence all points should be outside)
        var polygon = SMPolygon(vertices: [])
        XCTAssertFalse(polygon.contains(point: SMPoint(x: 1.0, y: 1.0)))
        // Test for a triangle with a point inside
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 2.0, y: 0.0), SMPoint(x: 1.0, y: 2.0)])
        XCTAssertTrue(polygon.contains(point: SMPoint(x: 1.0, y: 1.0)))
        // Test for a triangle with a point outside
        XCTAssertFalse(polygon.contains(point: SMPoint(x: -1.0, y: -1.0)))
        // Test for a square with a point on the edge
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 2.0, y: 0.0), SMPoint(x: 2.0, y: 2.0), SMPoint(x: 0.0, y: 2.0)])
        XCTAssertTrue(polygon.contains(point: SMPoint(x: 1.0, y: 0.0)))
        // Test for a square with a point inside
        XCTAssertTrue(polygon.contains(point: SMPoint(x: 1.0, y: 1.0)))
        // Test for a square with a point outside
        XCTAssertFalse(polygon.contains(point: SMPoint(x: 3.0, y: 3.0)))
        // Test for a complex polygon with a point inside
        polygon = SMPolygon(vertices: [SMPoint(x: 1.0, y: 0.0), SMPoint(x: 10.0, y: -10.0), SMPoint(x: 14.0, y: 4.0), SMPoint(x: 4.0, y: 12.0), SMPoint(x: 0.0, y: 4.0)])
        XCTAssertTrue(polygon.contains(point: SMPoint(x: 2, y: 3)))
        // Test for a complex polygon with a point outside
        XCTAssertFalse(polygon.contains(point: SMPoint(x: 0.0, y: 5.0)))
        // Test for a polygon with intersecting lines (invalid, hence all points should be outside)
        polygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 1.0, y: 0.0), SMPoint(x: 0.0, y: 1.0)])
        XCTAssertFalse(polygon.contains(point: SMPoint(x: 0.5, y: 0.5), validatePolygon: true))
    }
    
    func testContainsPolygon() throws {
        // Case 1: A polygon entirely within another
        let outerPolygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 5.0, y: 0.0), SMPoint(x: 5.0, y: 5.0), SMPoint(x: 0.0, y: 5.0)])
        let innerPolygon = SMPolygon(vertices: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 4.0, y: 1.0), SMPoint(x: 4.0, y: 4.0), SMPoint(x: 1.0, y: 4.0)])
        XCTAssertTrue(outerPolygon.contains(geometry: innerPolygon))
        XCTAssertTrue(outerPolygon.encloses(geometry: innerPolygon))
        // Case 2: A polygon partially overlapping another
        let partiallyOverlappingPolygon = SMPolygon(vertices: [SMPoint(x: 3.0, y: 3.0), SMPoint(x: 6.0, y: 3.0), SMPoint(x: 6.0, y: 6.0), SMPoint(x: 3.0, y: 6.0)])
        XCTAssertFalse(outerPolygon.contains(geometry: partiallyOverlappingPolygon))
        XCTAssertFalse(outerPolygon.encloses(geometry: partiallyOverlappingPolygon))
        // Case 3: A polygon completely outside another
        let outsidePolygon = SMPolygon(vertices: [SMPoint(x: 6.0, y: 6.0), SMPoint(x: 7.0, y: 6.0), SMPoint(x: 7.0, y: 7.0), SMPoint(x: 6.0, y: 7.0)])
        XCTAssertFalse(outerPolygon.contains(geometry: outsidePolygon))
        XCTAssertFalse(outerPolygon.encloses(geometry: outsidePolygon))
        // Case 4: Polygons with one inside the other, but sharing an edge
        let edgeSharingPolygon = SMPolygon(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 5.0, y: 0.0), SMPoint(x: 5.0, y: 5.0)])
        XCTAssertTrue(outerPolygon.contains(geometry: edgeSharingPolygon))
        XCTAssertFalse(outerPolygon.encloses(geometry: edgeSharingPolygon))
        // Case 5: Invalid polygon
        let invalidPolygon = SMPolygon(vertices: [SMPoint(x: 1.0, y: 1.0)]) // Invalid as it's not a polygon
        XCTAssertTrue(outerPolygon.contains(geometry: invalidPolygon))
        XCTAssertTrue(outerPolygon.encloses(geometry: invalidPolygon))
        // Case 6: Sticking out polygon
        let vShapePolygon = SMPolygon(vertices: SMPoint(x: -10, y: 0), SMPoint(x: 10, y: 0), SMPoint(x: 10, y: 10), SMPoint(x: 0, y: 5), SMPoint(x: -10, y: 10))
        let vIntersectPolygon = SMPolygon(vertices: SMPoint(x: -5, y: 2), SMPoint(x: 5, y: 2), SMPoint(x: 5, y: 6), SMPoint(x: -5, y: 6))
        XCTAssertFalse(vShapePolygon.contains(geometry: vIntersectPolygon))
        XCTAssertFalse(vShapePolygon.encloses(geometry: vIntersectPolygon))
        // Case 7: Touching polygons
        let touchingPolygon = SMPolygon(vertices: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 4.0, y: 1.0), SMPoint(x: 5.0, y: 2.5), SMPoint(x: 4.0, y: 4.0), SMPoint(x: 1.0, y: 4.0)])
        XCTAssertTrue(outerPolygon.contains(geometry: touchingPolygon, checkEdges: true))
        XCTAssertFalse(outerPolygon.encloses(geometry: touchingPolygon))
        // Case 8: Extruding polygons
        let extrudingPolygon = SMPolygon(vertices: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 4.0, y: 1.0), SMPoint(x: 5.0, y: 2.0), SMPoint(x: 6.0, y: 2.5), SMPoint(x: 4.0, y: 3.0), SMPoint(x: 4.0, y: 4.0), SMPoint(x: 1.0, y: 4.0)])
        XCTAssertFalse(outerPolygon.contains(geometry: extrudingPolygon, checkEdges: true))
        XCTAssertFalse(outerPolygon.encloses(geometry: extrudingPolygon))
    }
    
    func testClockwise() throws {
        // Case 1: Clockwise polygon
        let clockwisePolygon = SMPolygon(vertices: [
            SMPoint(x: 0, y: 0),
            SMPoint(x: 0, y: 1),
            SMPoint(x: 1, y: 1),
            SMPoint(x: 1, y: 0)
        ])
        XCTAssertTrue(clockwisePolygon.isClockwise)
        XCTAssertFalse(clockwisePolygon.isAnticlockwise)
        // Case 2: Anticlockwise polygon
        let anticlockwisePolygon = SMPolygon(vertices: [
            SMPoint(x: 0, y: 0),
            SMPoint(x: 1, y: 0),
            SMPoint(x: 1, y: 1),
            SMPoint(x: 0, y: 1)
        ])
        XCTAssertFalse(anticlockwisePolygon.isClockwise)
        XCTAssertTrue(anticlockwisePolygon.isAnticlockwise)
        // Case 3: Not a valid polygon (e.g., a line)
        let invalidPolygon = SMPolygon(vertices: [
            SMPoint(x: 0, y: 0),
            SMPoint(x: 1, y: 1)
        ])
        XCTAssertFalse(invalidPolygon.isClockwise)
        XCTAssertFalse(invalidPolygon.isAnticlockwise)
    }
    
    func testEquivalent() throws {
        let polygon1 = SMPolygon(vertices: SMPoint(), SMPoint(x: 1, y: 1))
        let polygon2 = SMPolygon(vertices: SMPoint(x: 1, y: 1), SMPoint())
        let polygon3 = SMPolygon(vertices: SMPoint(), SMPoint(x: 1.1, y: 1))
        XCTAssertTrue(polygon1.matchesGeometry(of: polygon2))
        XCTAssertFalse(polygon1.matchesGeometry(of: polygon3))
        
        let triangle1 = SMPolygon(vertices: SMPoint(x: 0, y: 0), SMPoint(x: 1, y: 0), SMPoint(x: 1, y: 1))
        let triangle2 = SMPolygon(vertices: SMPoint(x: 1, y: 0), SMPoint(x: 1, y: 1), SMPoint(x: 0, y: 0))
        XCTAssertTrue(triangle1.matchesGeometry(of: triangle2))
        
        let reversedTriangle1 = triangle1.clone()
        reversedTriangle1.reverse()
        XCTAssertTrue(triangle1.matchesGeometry(of: reversedTriangle1))
    }

}
