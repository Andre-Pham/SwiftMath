//
//  SMPolylineTests.swift
//
//
//  Created by Andre Pham on 22/1/2024.
//

import XCTest
import SwiftMath

final class SMPolylineTests: XCTestCase {
    
    func testEdges() throws {
        // Test for an empty polyline
        var polyline = SMPolyline(vertices: [])
        XCTAssertTrue(polyline.edges.isEmpty)

        // Test for a polyline with only one point
        polyline = SMPolyline(vertices: [SMPoint(x: 1.0, y: 1.0)])
        XCTAssertTrue(polyline.edges.isEmpty)

        // Test for a polyline with two points
        polyline = SMPolyline(vertices: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 2.0)])
        XCTAssertEqual(polyline.edges.count, 1)

        // Test for a polyline with multiple points
        polyline = SMPolyline(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 0.0)])
        XCTAssertEqual(polyline.edges.count, 2)
    }

    func testIsValid() throws {
        // Test for an empty polyline
        var polyline = SMPolyline(vertices: [])
        XCTAssertFalse(polyline.isValid)

        // Test for a polyline with only one point
        polyline = SMPolyline(vertices: [SMPoint(x: 1.0, y: 1.0)])
        XCTAssertFalse(polyline.isValid)

        // Test for a polyline with two points
        polyline = SMPolyline(vertices: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 2.0)])
        XCTAssertTrue(polyline.isValid)

        // Test for a polyline with multiple points
        polyline = SMPolyline(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 0.0)])
        XCTAssertTrue(polyline.isValid)
    }

    func testLength() throws {
        // Test for an empty polyline
        var polyline = SMPolyline(vertices: [])
        XCTAssertEqual(polyline.length, 0.0)

        // Test for a polyline with only one point
        polyline = SMPolyline(vertices: [SMPoint(x: 1.0, y: 1.0)])
        XCTAssertEqual(polyline.length, 0.0)

        // Test for a polyline with two points
        polyline = SMPolyline(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 3.0, y: 4.0)])
        XCTAssertEqual(polyline.length, 5.0)

        // Test for a polyline with multiple points
        polyline = SMPolyline(vertices: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 3.0, y: 4.0), SMPoint(x: 6.0, y: 0.0)])
        XCTAssertEqual(polyline.length, 10.0)
    }
    
}
