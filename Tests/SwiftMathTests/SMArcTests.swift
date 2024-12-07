//
//  SMAngleTests.swift
//  SwiftMathTests
//
//  Created by Andre Pham on 7/1/2024.
//

import XCTest
@testable import SwiftMath

final class SMArcTests: XCTestCase {

    func testStartEndPoints() throws {
        var arc: SMArc
        
        arc = SMArc(radius: 10.0, startAngle: SMAngle(degrees: 0.0), endAngle: SMAngle(degrees: 90.0))
        XCTAssertEqual(arc.startPoint, SMPoint(x: 10.0, y: 0.0))
        XCTAssertEqual(arc.endPoint, SMPoint(x: 0.0, y: 10.0))
        
        arc = SMArc(
            center: SMPoint(x: 5.0, y: 10.0),
            radius: 1.0,
            startAngle: SMAngle(degrees: -90.0),
            endAngle: SMAngle(degrees: 180.0)
        )
        XCTAssertEqual(arc.startPoint, SMPoint(x: 5.0, y: 9.0))
        XCTAssertEqual(arc.endPoint, SMPoint(x: 4.0, y: 10.0))
    }
    
    func testAdjustLength() throws {
        let center = SMPoint(x: 0, y: 0)
        let radius: Double = 5
        let arc = SMArc(center: center, radius: radius, startAngle: SMAngle(degrees: 20), endAngle: SMAngle(degrees: 90))
        let originalLength = arc.length
        var testArc: SMArc
        
        // Extend the arc
        testArc = arc.clone()
        testArc.adjustLength(by: 2.0)
        XCTAssertTrue(testArc.length.isEqual(to: originalLength + 2.0))
        XCTAssertTrue(testArc.startAngle == arc.startAngle)
        
        // Contract the arc
        testArc = arc.clone()
        testArc.adjustLength(by: -2.0)
        XCTAssertTrue(testArc.length.isEqual(to: originalLength - 2.0))
        XCTAssertTrue(testArc.startAngle == arc.startAngle)
        
        // Extend further than possible
        testArc = arc.clone()
        testArc.adjustLength(by: testArc.circumference + 1.0)
        XCTAssertTrue(testArc.length.isEqual(to: originalLength + 1.0))
        XCTAssertTrue(testArc.startAngle == arc.startAngle)
        
        // Negative adjustment is greater than the original length, inverting the arc
        testArc = arc.clone()
        testArc.adjustLength(by: -10.0)
        XCTAssertTrue(testArc.length.isEqual(to: abs(originalLength - 10.0)))
        XCTAssertTrue(testArc.endAngle == arc.startAngle)
        
        // Contract further than possible
        testArc = arc.clone()
        testArc.adjustLength(by: -testArc.circumference - 1.0)
        XCTAssertTrue(testArc.length.isEqual(to: originalLength - 1.0))
        XCTAssertTrue(testArc.startAngle == arc.startAngle)
    }
    
    func testSetLength() throws {
        let center = SMPoint(x: 0, y: 0)
        let radius: Double = 5
        let arc = SMArc(center: center, radius: radius, startAngle: SMAngle(degrees: 20), endAngle: SMAngle(degrees: 90))
        let originalLength = arc.length
        var testArc: SMArc
        
        // Set the arc to a new length
        testArc = arc.clone()
        testArc.setLength(to: 1.0)
        XCTAssertTrue(testArc.length.isEqual(to: 1.0))
        XCTAssertTrue(testArc.startAngle == arc.startAngle)
        
        // Set the arc to an impossible new length
        testArc = arc.clone()
        testArc.setLength(to: testArc.circumference + 1.0)
        XCTAssertTrue(testArc.length.isEqual(to: 1.0))
        XCTAssertTrue(testArc.startAngle == arc.startAngle)
        
        // Set the arc to a negative length
        testArc = arc.clone()
        testArc.setLength(to: -1.0)
        XCTAssertTrue(testArc.length.isEqual(to: 1.0))
        XCTAssertTrue(testArc.endAngle == arc.startAngle)
        
        // Set the arc to an impossible negative length
        testArc = arc.clone()
        testArc.setLength(to: -testArc.circumference - 1.0)
        XCTAssertTrue(testArc.length.isEqual(to: 1.0))
        XCTAssertTrue(testArc.endAngle == arc.startAngle)
    }

}
