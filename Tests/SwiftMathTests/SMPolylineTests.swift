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
    
    func testRoundedCorners() throws {
        // Test 3 vertex polyline
        var polyline = SMPolyline(vertices: [SMPoint(x: 0, y: 0), SMPoint(x: 10, y: 0), SMPoint(x: 10, y: -10)])
        var rounded = polyline.roundedCorners(pointDistance: 3, controlPointDistance: 2)
        XCTAssertEqual(rounded.edgeCount, 3)
        if rounded.edgeCount != 3 {
            XCTFail()
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 2)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 1)
        if rounded.assortedLinearEdges.count != 2 || rounded.assortedBezierEdges.count != 1 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedLinearEdges[0].origin == SMPoint(x: 0, y: 0))
        XCTAssertTrue(rounded.sortedLinearEdges[0].end == SMPoint(x: 7, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].origin == SMPoint(x: 7, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].originControlPoint == SMPoint(x: 9, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].end == SMPoint(x: 10, y: -3))
        XCTAssertTrue(rounded.sortedBezierEdges[0].endControlPoint == SMPoint(x: 10, y: -1))
        XCTAssertTrue(rounded.sortedLinearEdges[1].origin == SMPoint(x: 10, y: -3))
        XCTAssertTrue(rounded.sortedLinearEdges[1].end == SMPoint(x: 10, y: -10))
        
        // Test 4 vertex polyline
        polyline = SMPolyline(vertices: [SMPoint(x: 0, y: 0), SMPoint(x: 10, y: 0), SMPoint(x: 10, y: -10), SMPoint(x: 20, y: -10)])
        rounded = polyline.roundedCorners(pointDistance: 3, controlPointDistance: 2)
        XCTAssertEqual(rounded.edgeCount, 5)
        if rounded.edgeCount != 5 {
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 3)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 2)
        if rounded.assortedLinearEdges.count != 3 || rounded.assortedBezierEdges.count != 2 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedLinearEdges[0].origin == SMPoint(x: 0, y: 0))
        XCTAssertTrue(rounded.sortedLinearEdges[0].end == SMPoint(x: 7, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].origin == SMPoint(x: 7, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].originControlPoint == SMPoint(x: 9, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].end == SMPoint(x: 10, y: -3))
        XCTAssertTrue(rounded.sortedBezierEdges[0].endControlPoint == SMPoint(x: 10, y: -1))
        XCTAssertTrue(rounded.sortedLinearEdges[1].origin == SMPoint(x: 10, y: -3))
        XCTAssertTrue(rounded.sortedLinearEdges[1].end == SMPoint(x: 10, y: -7))
        XCTAssertTrue(rounded.sortedBezierEdges[1].origin == SMPoint(x: 10, y: -7))
        XCTAssertTrue(rounded.sortedBezierEdges[1].originControlPoint == SMPoint(x: 10, y: -9))
        XCTAssertTrue(rounded.sortedBezierEdges[1].end == SMPoint(x: 13, y: -10))
        XCTAssertTrue(rounded.sortedBezierEdges[1].endControlPoint == SMPoint(x: 11, y: -10))
        XCTAssertTrue(rounded.sortedLinearEdges[2].origin == SMPoint(x: 13, y: -10))
        XCTAssertTrue(rounded.sortedLinearEdges[2].end == SMPoint(x: 20, y: -10))
        
        // Test 4 vertex polyline with point distance and control point distance longer than edge lengths
        polyline = SMPolyline(vertices: [SMPoint(x: -6, y: 0), SMPoint(x: 10, y: 0), SMPoint(x: 10, y: -10), SMPoint(x: 50, y: -10)])
        rounded = polyline.roundedCorners(pointDistance: 20, controlPointDistance: 12)
        XCTAssertEqual(rounded.edgeCount, 4)
        if rounded.edgeCount != 4 {
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 2)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 2)
        if rounded.assortedLinearEdges.count != 2 || rounded.assortedBezierEdges.count != 2 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedLinearEdges[0].origin == SMPoint(x: -6, y: 0))
        XCTAssertTrue(rounded.sortedLinearEdges[0].end == SMPoint(x: 5, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].origin == SMPoint(x: 5, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].originControlPoint == SMPoint(x: 10, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].end == SMPoint(x: 10, y: -5))
        XCTAssertTrue(rounded.sortedBezierEdges[0].endControlPoint == SMPoint(x: 10, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[1].origin == SMPoint(x: 10, y: -5))
        XCTAssertTrue(rounded.sortedBezierEdges[1].originControlPoint == SMPoint(x: 10, y: -10))
        XCTAssertTrue(rounded.sortedBezierEdges[1].end == SMPoint(x: 15, y: -10))
        XCTAssertTrue(rounded.sortedBezierEdges[1].endControlPoint == SMPoint(x: 10, y: -10))
        XCTAssertTrue(rounded.sortedLinearEdges[1].origin == SMPoint(x: 15, y: -10))
        XCTAssertTrue(rounded.sortedLinearEdges[1].end == SMPoint(x: 50, y: -10))
        
        // Test varying point distances within same edge
        polyline = SMPolyline(vertices: [SMPoint(x: 9, y: 0), SMPoint(x: 10, y: 0), SMPoint(x: 10, y: -10), SMPoint(x: 0, y: -10)])
        rounded = polyline.roundedCorners(pointDistance: 3, controlPointDistance: 2)
        XCTAssertEqual(rounded.edgeCount, 4)
        if rounded.edgeCount != 4 {
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 2)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 2)
        if rounded.assortedLinearEdges.count != 2 || rounded.assortedBezierEdges.count != 2 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedBezierEdges[0].origin == SMPoint(x: 9, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].originControlPoint == SMPoint(x: 10, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].end == SMPoint(x: 10, y: -1))
        XCTAssertTrue(rounded.sortedBezierEdges[0].endControlPoint == SMPoint(x: 10, y: 0))
        XCTAssertTrue(rounded.sortedLinearEdges[0].origin == SMPoint(x: 10, y: -1))
        XCTAssertTrue(rounded.sortedLinearEdges[0].end == SMPoint(x: 10, y: -7))
        XCTAssertTrue(rounded.sortedBezierEdges[1].origin == SMPoint(x: 10, y: -7))
        XCTAssertTrue(rounded.sortedBezierEdges[1].originControlPoint == SMPoint(x: 10, y: -9))
        XCTAssertTrue(rounded.sortedBezierEdges[1].end == SMPoint(x: 7, y: -10))
        XCTAssertTrue(rounded.sortedBezierEdges[1].endControlPoint == SMPoint(x: 9, y: -10))
        XCTAssertTrue(rounded.sortedLinearEdges[1].origin == SMPoint(x: 7, y: -10))
        XCTAssertTrue(rounded.sortedLinearEdges[1].end == SMPoint(x: 0, y: -10))
        
        // Test varying point distances within same edge, point distance > edge distance/2
        polyline = SMPolyline(vertices: [SMPoint(x: 9, y: 0), SMPoint(x: 10, y: 0), SMPoint(x: 10, y: -10), SMPoint(x: 0, y: -10)])
        rounded = polyline.roundedCorners(pointDistance: 6, controlPointDistance: 2)
        XCTAssertEqual(rounded.edgeCount, 4)
        if rounded.edgeCount != 4 {
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 2)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 2)
        if rounded.assortedLinearEdges.count != 2 || rounded.assortedBezierEdges.count != 2 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedBezierEdges[0].origin == SMPoint(x: 9, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].originControlPoint == SMPoint(x: 10, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].end == SMPoint(x: 10, y: -1))
        XCTAssertTrue(rounded.sortedBezierEdges[0].endControlPoint == SMPoint(x: 10, y: 0))
        XCTAssertTrue(rounded.sortedLinearEdges[0].origin == SMPoint(x: 10, y: -1))
        XCTAssertTrue(rounded.sortedLinearEdges[0].end == SMPoint(x: 10, y: -4))
        XCTAssertTrue(rounded.sortedBezierEdges[1].origin == SMPoint(x: 10, y: -4))
        XCTAssertTrue(rounded.sortedBezierEdges[1].originControlPoint == SMPoint(x: 10, y: -6))
        XCTAssertTrue(rounded.sortedBezierEdges[1].end == SMPoint(x: 4, y: -10))
        XCTAssertTrue(rounded.sortedBezierEdges[1].endControlPoint == SMPoint(x: 6, y: -10))
        XCTAssertTrue(rounded.sortedLinearEdges[1].origin == SMPoint(x: 4, y: -10))
        XCTAssertTrue(rounded.sortedLinearEdges[1].end == SMPoint(x: 0, y: -10))
        
        // Test varying point distances within same edge, point distance > edge distance, control point distance > point distance
        polyline = SMPolyline(vertices: [SMPoint(x: 9, y: 0), SMPoint(x: 10, y: 0), SMPoint(x: 10, y: -10), SMPoint(x: 0, y: -10)])
        rounded = polyline.roundedCorners(pointDistance: 11, controlPointDistance: 12)
        XCTAssertEqual(rounded.edgeCount, 3)
        if rounded.edgeCount != 3 {
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 1)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 2)
        if rounded.assortedLinearEdges.count != 1 || rounded.assortedBezierEdges.count != 2 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedBezierEdges[0].origin == SMPoint(x: 9, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].originControlPoint == SMPoint(x: 10, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].end == SMPoint(x: 10, y: -1))
        XCTAssertTrue(rounded.sortedBezierEdges[0].endControlPoint == SMPoint(x: 10, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[1].origin == SMPoint(x: 10, y: -1))
        XCTAssertTrue(rounded.sortedBezierEdges[1].originControlPoint == SMPoint(x: 10, y: -10))
        XCTAssertTrue(rounded.sortedBezierEdges[1].end == SMPoint(x: 1, y: -10))
        XCTAssertTrue(rounded.sortedBezierEdges[1].endControlPoint == SMPoint(x: 10, y: -10))
        XCTAssertTrue(rounded.sortedLinearEdges[0].origin == SMPoint(x: 1, y: -10))
        XCTAssertTrue(rounded.sortedLinearEdges[0].end == SMPoint(x: 0, y: -10))
        
        // Test points that lie on a straight line reduce point distances if they intercept
        polyline = SMPolyline(vertices: [SMPoint(), SMPoint(x: 4, y: 0), SMPoint(x: 5, y: 0), SMPoint(x: 5, y: 5)])
        rounded = polyline.roundedCorners(pointDistance: 4, controlPointDistance: 2)
        XCTAssertEqual(rounded.edgeCount, 3)
        if rounded.edgeCount != 3 {
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 2)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 1)
        if rounded.assortedLinearEdges.count != 2 || rounded.assortedBezierEdges.count != 1 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedLinearEdges[0].origin == SMPoint())
        XCTAssertTrue(rounded.sortedLinearEdges[0].end == SMPoint(x: 4, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].origin == SMPoint(x: 4, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].originControlPoint == SMPoint(x: 5, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].end == SMPoint(x: 5, y: 1))
        XCTAssertTrue(rounded.sortedBezierEdges[0].endControlPoint == SMPoint(x: 5, y: 0))
        XCTAssertTrue(rounded.sortedLinearEdges[1].origin == SMPoint(x: 5, y: 1))
        XCTAssertTrue(rounded.sortedLinearEdges[1].end == SMPoint(x: 5, y: 5))
        
        // Test straight line
        polyline = SMPolyline(vertices: SMPoint(), SMPoint(x: 0, y: -10), SMPoint(x: 0, y: -20))
        rounded = polyline.roundedCorners(pointDistance: 3, controlPointDistance: 2)
        XCTAssertEqual(rounded.edgeCount, 1)
        if rounded.edgeCount != 1 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedLinearEdges[0].origin == SMPoint())
        XCTAssertTrue(rounded.sortedLinearEdges[0].end == SMPoint(x: 0, y: -20))
        
        // Test straight line with many vertices and a curve
        polyline = SMPolyline(vertices: [
            SMPoint(x: 0, y: 0),
            SMPoint(x: 1, y: 0),
            SMPoint(x: 2, y: 0),
            SMPoint(x: 3, y: 0),
            SMPoint(x: 10, y: 0),
            SMPoint(x: 10, y: -7),
            SMPoint(x: 10, y: -8),
            SMPoint(x: 10, y: -9),
            SMPoint(x: 10, y: -10)
        ])
        rounded = polyline.roundedCorners(pointDistance: 3, controlPointDistance: 2)
        XCTAssertEqual(rounded.edgeCount, 3)
        if rounded.edgeCount != 3 {
            XCTFail()
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 2)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 1)
        if rounded.assortedLinearEdges.count != 2 || rounded.assortedBezierEdges.count != 1 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedLinearEdges[0].origin == SMPoint(x: 0, y: 0))
        XCTAssertTrue(rounded.sortedLinearEdges[0].end == SMPoint(x: 7, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].origin == SMPoint(x: 7, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].originControlPoint == SMPoint(x: 9, y: 0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].end == SMPoint(x: 10, y: -3))
        XCTAssertTrue(rounded.sortedBezierEdges[0].endControlPoint == SMPoint(x: 10, y: -1))
        XCTAssertTrue(rounded.sortedLinearEdges[1].origin == SMPoint(x: 10, y: -3))
        XCTAssertTrue(rounded.sortedLinearEdges[1].end == SMPoint(x: 10, y: -10))
        
        // Test non right angles work
        polyline = SMPolyline(vertices: [SMPoint(x: 0, y: 0), SMPoint(x: 0, y: 500), SMPoint(x: 500, y: 700), SMPoint(x: 500, y: 1200)])
        rounded = polyline.roundedCorners(pointDistance: 250, controlPointDistance: 200)
        XCTAssertEqual(rounded.edgeCount, 5)
        if rounded.edgeCount != 5 {
            XCTFail()
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 3)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 2)
        if rounded.assortedLinearEdges.count != 3 || rounded.assortedBezierEdges.count != 2 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedLinearEdges[0].origin == SMPoint(x: 0.0, y: 0.0))
        XCTAssertTrue(rounded.sortedLinearEdges[0].end == SMPoint(x: 0.0, y: 250.0))
        XCTAssertTrue(rounded.sortedLinearEdges[1].origin == SMPoint(x: 232.11917272131484, y: 592.847669088526))
        XCTAssertTrue(rounded.sortedLinearEdges[1].end == SMPoint(x: 267.88082727868516, y: 607.1523309114741))
        XCTAssertTrue(rounded.sortedLinearEdges[2].origin == SMPoint(x: 500.0, y: 950.0))
        XCTAssertTrue(rounded.sortedLinearEdges[2].end == SMPoint(x: 500.0, y: 1200.0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].origin == SMPoint(x: 0.0, y: 250.0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].originControlPoint == SMPoint(x: 2.7554552980815446e-14, y: 450.0))
        XCTAssertTrue(rounded.sortedBezierEdges[0].end == SMPoint(x: 232.11917272131484, y: 592.8476690885259))
        XCTAssertTrue(rounded.sortedBezierEdges[0].endControlPoint == SMPoint(x: 46.423834544263, y: 518.5695338177052))
        XCTAssertTrue(rounded.sortedBezierEdges[1].origin == SMPoint(x: 267.88082727868516, y: 607.1523309114741))
        XCTAssertTrue(rounded.sortedBezierEdges[1].originControlPoint == SMPoint(x: 453.576165455737, y: 681.4304661822948))
        XCTAssertTrue(rounded.sortedBezierEdges[1].end == SMPoint(x: 500.0, y: 950.0))
        XCTAssertTrue(rounded.sortedBezierEdges[1].endControlPoint == SMPoint(x: 500.0, y: 750.0))
        
        // Test point distance algorithm - scenario #1
        polyline = SMPolyline(vertices: SMPoint(), SMPoint(x: 1, y: 0), SMPoint(x: 1, y: -5), SMPoint(x: 6, y: -5), SMPoint(x: 6, y: 5), SMPoint(x: 9, y: 5))
        rounded = polyline.roundedCorners(pointDistance: 100, controlPointDistance: 100)
        XCTAssertEqual(rounded.edgeCount, 6)
        if rounded.edgeCount != 6 {
            XCTFail()
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 2)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 4)
        if rounded.assortedLinearEdges.count != 2 || rounded.assortedBezierEdges.count != 4 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedBezierEdges[0] == SMBezierCurve(
            origin: SMPoint(),
            originControlPoint: SMPoint(x: 1, y: 0),
            end: SMPoint(x: 1, y: -1),
            endControlPoint: SMPoint(x: 1, y: 0)
        ))
        XCTAssertTrue(rounded.sortedLinearEdges[0] == SMLineSegment(
            origin: SMPoint(x: 1, y: -1),
            end: SMPoint(x: 1, y: -2.5)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[1] == SMBezierCurve(
            origin: SMPoint(x: 1, y: -2.5),
            originControlPoint: SMPoint(x: 1, y: -5),
            end: SMPoint(x: 3.5, y: -5),
            endControlPoint: SMPoint(x: 1, y: -5)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[2] == SMBezierCurve(
            origin: SMPoint(x: 3.5, y: -5),
            originControlPoint: SMPoint(x: 6, y: -5),
            end: SMPoint(x: 6, y: -2.5),
            endControlPoint: SMPoint(x: 6, y: -5)
        ))
        XCTAssertTrue(rounded.sortedLinearEdges[1] == SMLineSegment(
            origin: SMPoint(x: 6, y: -2.5),
            end: SMPoint(x: 6, y: 2)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[3] == SMBezierCurve(
            origin: SMPoint(x: 6, y: 2),
            originControlPoint: SMPoint(x: 6, y: 5),
            end: SMPoint(x: 9, y: 5),
            endControlPoint: SMPoint(x: 6, y: 5)
        ))
        
        // Test point distance algorithm - scenario #2
        polyline = SMPolyline(vertices: SMPoint(), SMPoint(x: 1, y: 0), SMPoint(x: 1, y: -5), SMPoint(x: 6, y: -5), SMPoint(x: 6, y: 5))
        rounded = polyline.roundedCorners(pointDistance: 100, controlPointDistance: 100)
        XCTAssertEqual(rounded.edgeCount, 5)
        if rounded.edgeCount != 5 {
            XCTFail()
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 2)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 3)
        if rounded.assortedLinearEdges.count != 2 || rounded.assortedBezierEdges.count != 3 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedBezierEdges[0] == SMBezierCurve(
            origin: SMPoint(),
            originControlPoint: SMPoint(x: 1, y: 0),
            end: SMPoint(x: 1, y: -1),
            endControlPoint: SMPoint(x: 1, y: 0)
        ))
        XCTAssertTrue(rounded.sortedLinearEdges[0] == SMLineSegment(
            origin: SMPoint(x: 1, y: -1),
            end: SMPoint(x: 1, y: -2.5)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[1] == SMBezierCurve(
            origin: SMPoint(x: 1, y: -2.5),
            originControlPoint: SMPoint(x: 1, y: -5),
            end: SMPoint(x: 3.5, y: -5),
            endControlPoint: SMPoint(x: 1, y: -5)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[2] == SMBezierCurve(
            origin: SMPoint(x: 3.5, y: -5),
            originControlPoint: SMPoint(x: 6, y: -5),
            end: SMPoint(x: 6, y: -2.5),
            endControlPoint: SMPoint(x: 6, y: -5)
        ))
        XCTAssertTrue(rounded.sortedLinearEdges[1] == SMLineSegment(
            origin: SMPoint(x: 6, y: -2.5),
            end: SMPoint(x: 6, y: 5)
        ))
        
        // Test point distance algorithm - scenario #3
        polyline = SMPolyline(vertices: SMPoint(), SMPoint(x: 5, y: 0), SMPoint(x: 5, y: -5))
        rounded = polyline.roundedCorners(pointDistance: 100, controlPointDistance: 100)
        XCTAssertEqual(rounded.edgeCount, 1)
        if rounded.edgeCount != 1 {
            XCTFail()
            return
        }
        XCTAssertEqual(rounded.assortedBezierEdges.count, 1)
        if rounded.assortedBezierEdges.count != 1 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedBezierEdges[0] == SMBezierCurve(
            origin: SMPoint(),
            originControlPoint: SMPoint(x: 5, y: 0),
            end: SMPoint(x: 5, y: -5),
            endControlPoint: SMPoint(x: 5, y: 0)
        ))
        
        // Test point distance algorithm - scenario #4
        polyline = SMPolyline(vertices: SMPoint(x: -1, y: 0), SMPoint(), SMPoint(x: 0, y: -5), SMPoint(x: 5, y: -5))
        rounded = polyline.roundedCorners(pointDistance: 100, controlPointDistance: 100)
        XCTAssertEqual(rounded.edgeCount, 3)
        if rounded.edgeCount != 3 {
            XCTFail()
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 1)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 2)
        if rounded.assortedLinearEdges.count != 1 || rounded.assortedBezierEdges.count != 2 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedBezierEdges[0] == SMBezierCurve(
            origin: SMPoint(x: -1, y: 0),
            originControlPoint: SMPoint(),
            end: SMPoint(x: 0, y: -1),
            endControlPoint: SMPoint()
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[1] == SMBezierCurve(
            origin: SMPoint(x: 0, y: -1),
            originControlPoint: SMPoint(x: 0, y: -5),
            end: SMPoint(x: 4, y: -5),
            endControlPoint: SMPoint(x: 0, y: -5)
        ))
        XCTAssertTrue(rounded.sortedLinearEdges[0] == SMLineSegment(
            origin: SMPoint(x: 4, y: -5),
            end: SMPoint(x: 5, y: -5)
        ))
        
        // Test point distance algorithm - scenario #5
        polyline = SMPolyline(vertices: SMPoint(x: -5, y: 0), SMPoint(), SMPoint(x: 0, y: -1), SMPoint(x: 5, y: -1))
        rounded = polyline.roundedCorners(pointDistance: 100, controlPointDistance: 100)
        XCTAssertEqual(rounded.edgeCount, 4)
        if rounded.edgeCount != 4 {
            XCTFail()
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 2)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 2)
        if rounded.assortedLinearEdges.count != 2 || rounded.assortedBezierEdges.count != 2 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedLinearEdges[0] == SMLineSegment(
            origin: SMPoint(x: -5, y: 0),
            end: SMPoint(x: -0.5, y: 0)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[0] == SMBezierCurve(
            origin: SMPoint(x: -0.5, y: 0),
            originControlPoint: SMPoint(),
            end: SMPoint(x: 0, y: -0.5),
            endControlPoint: SMPoint()
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[1] == SMBezierCurve(
            origin: SMPoint(x: 0, y: -0.5),
            originControlPoint: SMPoint(x: 0, y: -1),
            end: SMPoint(x: 0.5, y: -1),
            endControlPoint: SMPoint(x: 0, y: -1)
        ))
        XCTAssertTrue(rounded.sortedLinearEdges[1] == SMLineSegment(
            origin: SMPoint(x: 0.5, y: -1),
            end: SMPoint(x: 5, y: -1)
        ))
        
        // Test point distance algorithm - scenario #6
        polyline = SMPolyline(vertices: SMPoint(x: 0, y: 1), SMPoint(), SMPoint(x: 5, y: 0), SMPoint(x: 5, y: 1))
        rounded = polyline.roundedCorners(pointDistance: 100, controlPointDistance: 100)
        XCTAssertEqual(rounded.edgeCount, 3)
        if rounded.edgeCount != 3 {
            XCTFail()
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 1)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 2)
        if rounded.assortedLinearEdges.count != 1 || rounded.assortedBezierEdges.count != 2 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedBezierEdges[0] == SMBezierCurve(
            origin: SMPoint(x: 0, y: 1),
            originControlPoint: SMPoint(),
            end: SMPoint(x: 1, y: 0),
            endControlPoint: SMPoint()
        ))
        XCTAssertTrue(rounded.sortedLinearEdges[0] == SMLineSegment(
            origin: SMPoint(x: 1, y: 0),
            end: SMPoint(x: 4, y: 0)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[1] == SMBezierCurve(
            origin: SMPoint(x: 4, y: 0),
            originControlPoint: SMPoint(x: 5, y: 0),
            end: SMPoint(x: 5, y: 1),
            endControlPoint: SMPoint(x: 5, y: 0)
        ))
        
        // Test point distance algorithm - scenario #7
        polyline = SMPolyline(vertices: SMPoint(x: 0, y: 3), SMPoint(), SMPoint(x: 6, y: 0), SMPoint(x: 6, y: 3), SMPoint(x: 12, y: 3))
        rounded = polyline.roundedCorners(pointDistance: 100, controlPointDistance: 100)
        XCTAssertEqual(rounded.edgeCount, 5)
        if rounded.edgeCount != 5 {
            XCTFail()
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 2)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 3)
        if rounded.assortedLinearEdges.count != 2 || rounded.assortedBezierEdges.count != 3 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedBezierEdges[0] == SMBezierCurve(
            origin: SMPoint(x: 0, y: 3),
            originControlPoint: SMPoint(),
            end: SMPoint(x: 3, y: 0),
            endControlPoint: SMPoint()
        ))
        XCTAssertTrue(rounded.sortedLinearEdges[0] == SMLineSegment(
            origin: SMPoint(x: 3, y: 0),
            end: SMPoint(x: 4.5, y: 0)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[1] == SMBezierCurve(
            origin: SMPoint(x: 4.5, y: 0),
            originControlPoint: SMPoint(x: 6, y: 0),
            end: SMPoint(x: 6, y: 1.5),
            endControlPoint: SMPoint(x: 6, y: 0)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[2] == SMBezierCurve(
            origin: SMPoint(x: 6, y: 1.5),
            originControlPoint: SMPoint(x: 6, y: 3),
            end: SMPoint(x: 7.5, y: 3),
            endControlPoint: SMPoint(x: 6, y: 3)
        ))
        XCTAssertTrue(rounded.sortedLinearEdges[1] == SMLineSegment(
            origin: SMPoint(x: 7.5, y: 3),
            end: SMPoint(x: 12, y: 3)
        ))
        
        // Test point distance algorithm - scenario #8
        polyline = SMPolyline(vertices: SMPoint(x: 0, y: 1), SMPoint(), SMPoint(x: 5, y: 0), SMPoint(x: 5, y: -10), SMPoint(x: 10, y: -10), SMPoint(x: 10, y: -20))
        rounded = polyline.roundedCorners(pointDistance: 100, controlPointDistance: 100)
        XCTAssertEqual(rounded.edgeCount, 6)
        if rounded.edgeCount != 6 {
            XCTFail()
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 2)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 4)
        if rounded.assortedLinearEdges.count != 2 || rounded.assortedBezierEdges.count != 4 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedBezierEdges[0] == SMBezierCurve(
            origin: SMPoint(x: 0, y: 1),
            originControlPoint: SMPoint(),
            end: SMPoint(x: 1, y: 0),
            endControlPoint: SMPoint()
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[1] == SMBezierCurve(
            origin: SMPoint(x: 1, y: 0),
            originControlPoint: SMPoint(x: 5, y: 0),
            end: SMPoint(x: 5, y: -4),
            endControlPoint: SMPoint(x: 5, y: 0)
        ))
        XCTAssertTrue(rounded.sortedLinearEdges[0] == SMLineSegment(
            origin: SMPoint(x: 5, y: -4),
            end: SMPoint(x: 5, y: -7.5)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[2] == SMBezierCurve(
            origin: SMPoint(x: 5, y: -7.5),
            originControlPoint: SMPoint(x: 5, y: -10),
            end: SMPoint(x: 7.5, y: -10),
            endControlPoint: SMPoint(x: 5, y: -10)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[3] == SMBezierCurve(
            origin: SMPoint(x: 7.5, y: -10),
            originControlPoint: SMPoint(x: 10, y: -10),
            end: SMPoint(x: 10, y: -12.5),
            endControlPoint: SMPoint(x: 10, y: -10)
        ))
        XCTAssertTrue(rounded.sortedLinearEdges[1] == SMLineSegment(
            origin: SMPoint(x: 10, y: -12.5),
            end: SMPoint(x: 10, y: -20)
        ))
        
        // Test point distance algorithm - scenario #9
        polyline = SMPolyline(vertices: SMPoint(x: -2, y: 15), SMPoint(x: -2, y: 4), SMPoint(x: 0, y: 4), SMPoint(), SMPoint(x: 5, y: 0), SMPoint(x: 5, y: -6))
        rounded = polyline.roundedCorners(pointDistance: 100, controlPointDistance: 100)
        XCTAssertEqual(rounded.edgeCount, 7)
        if rounded.edgeCount != 7 {
            XCTFail()
            return
        }
        XCTAssertEqual(rounded.assortedLinearEdges.count, 3)
        XCTAssertEqual(rounded.assortedBezierEdges.count, 4)
        if rounded.assortedLinearEdges.count != 3 || rounded.assortedBezierEdges.count != 4 {
            XCTFail()
            return
        }
        XCTAssertTrue(rounded.sortedLinearEdges[0] == SMLineSegment(
            origin: SMPoint(x: -2, y: 15),
            end: SMPoint(x: -2, y: 5)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[0] == SMBezierCurve(
            origin: SMPoint(x: -2, y: 5),
            originControlPoint: SMPoint(x: -2, y: 4),
            end: SMPoint(x: -1, y: 4),
            endControlPoint: SMPoint(x: -2, y: 4)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[1] == SMBezierCurve(
            origin: SMPoint(x: -1, y: 4),
            originControlPoint: SMPoint(x: 0, y: 4),
            end: SMPoint(x: 0, y: 3),
            endControlPoint: SMPoint(x: 0, y: 4)
        ))
        XCTAssertTrue(rounded.sortedLinearEdges[1] == SMLineSegment(
            origin: SMPoint(x: 0, y: 3),
            end: SMPoint(x: 0, y: 2.5)
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[2] == SMBezierCurve(
            origin: SMPoint(x: 0, y: 2.5),
            originControlPoint: SMPoint(),
            end: SMPoint(x: 2.5, y: 0),
            endControlPoint: SMPoint()
        ))
        XCTAssertTrue(rounded.sortedBezierEdges[3] == SMBezierCurve(
            origin: SMPoint(x: 2.5, y: 0),
            originControlPoint: SMPoint(x: 5, y: 0),
            end: SMPoint(x: 5, y: -2.5),
            endControlPoint: SMPoint(x: 5, y: 0)
        ))
        XCTAssertTrue(rounded.sortedLinearEdges[2] == SMLineSegment(
            origin: SMPoint(x: 5, y: -2.5),
            end: SMPoint(x: 5, y: -6)
        ))
    }
    
}
