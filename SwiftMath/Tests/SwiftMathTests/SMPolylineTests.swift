//
//  SMPolylineTests.swift
//
//
//  Created by Andre Pham on 22/1/2024.
//

import XCTest
import SwiftMath

final class SMPolylineTests: XCTestCase {
    
    func testLineSegments() throws {
        // Test for an empty polyline
        var polyline = SMPolyline(orderedPoints: [])
        XCTAssertTrue(polyline.lineSegments.isEmpty)

        // Test for a polyline with only one point
        polyline = SMPolyline(orderedPoints: [SMPoint(x: 1.0, y: 1.0)])
        XCTAssertTrue(polyline.lineSegments.isEmpty)

        // Test for a polyline with two points
        polyline = SMPolyline(orderedPoints: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 2.0)])
        XCTAssertEqual(polyline.lineSegments.count, 1)

        // Test for a polyline with multiple points
        polyline = SMPolyline(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 0.0)])
        XCTAssertEqual(polyline.lineSegments.count, 2)
    }

    func testIsValid() throws {
        // Test for an empty polyline
        var polyline = SMPolyline(orderedPoints: [])
        XCTAssertFalse(polyline.isValid)

        // Test for a polyline with only one point
        polyline = SMPolyline(orderedPoints: [SMPoint(x: 1.0, y: 1.0)])
        XCTAssertFalse(polyline.isValid)

        // Test for a polyline with two points
        polyline = SMPolyline(orderedPoints: [SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 2.0)])
        XCTAssertTrue(polyline.isValid)

        // Test for a polyline with multiple points
        polyline = SMPolyline(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 1.0, y: 1.0), SMPoint(x: 2.0, y: 0.0)])
        XCTAssertTrue(polyline.isValid)
    }

    func testLength() throws {
        // Test for an empty polyline
        var polyline = SMPolyline(orderedPoints: [])
        XCTAssertEqual(polyline.length, 0.0)

        // Test for a polyline with only one point
        polyline = SMPolyline(orderedPoints: [SMPoint(x: 1.0, y: 1.0)])
        XCTAssertEqual(polyline.length, 0.0)

        // Test for a polyline with two points
        polyline = SMPolyline(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 3.0, y: 4.0)])
        XCTAssertEqual(polyline.length, 5.0)

        // Test for a polyline with multiple points
        polyline = SMPolyline(orderedPoints: [SMPoint(x: 0.0, y: 0.0), SMPoint(x: 3.0, y: 4.0), SMPoint(x: 6.0, y: 0.0)])
        XCTAssertEqual(polyline.length, 10.0)
    }
    
}
