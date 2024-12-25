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
        testArc = arc
        testArc.adjustLength(by: 2.0)
        XCTAssertTrue(testArc.length.isEqual(to: originalLength + 2.0))
        XCTAssertTrue(testArc.startAngle == arc.startAngle)
        
        // Contract the arc
        testArc = arc
        testArc.adjustLength(by: -2.0)
        XCTAssertTrue(testArc.length.isEqual(to: originalLength - 2.0))
        XCTAssertTrue(testArc.startAngle == arc.startAngle)
        
        // Extend further than possible
        testArc = arc
        testArc.adjustLength(by: testArc.circumference + 1.0)
        XCTAssertTrue(testArc.length.isEqual(to: originalLength + 1.0))
        XCTAssertTrue(testArc.startAngle == arc.startAngle)
        
        // Negative adjustment is greater than the original length, inverting the arc
        testArc = arc
        testArc.adjustLength(by: -10.0)
        XCTAssertTrue(testArc.length.isEqual(to: abs(originalLength - 10.0)))
        XCTAssertTrue(testArc.endAngle == arc.startAngle)
        
        // Contract further than possible
        testArc = arc
        testArc.adjustLength(by: -testArc.circumference - 1.0)
        XCTAssertTrue(testArc.length.isEqual(to: originalLength - 1.0))
        XCTAssertTrue(testArc.startAngle == arc.startAngle)
    }
    
    func testSetLength() throws {
        let center = SMPoint(x: 0, y: 0)
        let radius: Double = 5
        let arc = SMArc(center: center, radius: radius, startAngle: SMAngle(degrees: 20), endAngle: SMAngle(degrees: 90))
        var testArc: SMArc
        
        // Set the arc to a new length
        testArc = arc
        testArc.setLength(to: 1.0)
        XCTAssertTrue(testArc.length.isEqual(to: 1.0))
        XCTAssertTrue(testArc.startAngle == arc.startAngle)
        
        // Set the arc to an impossible new length
        testArc = arc
        testArc.setLength(to: testArc.circumference + 1.0)
        XCTAssertTrue(testArc.length.isEqual(to: 1.0))
        XCTAssertTrue(testArc.startAngle == arc.startAngle)
        
        // Set the arc to a negative length
        testArc = arc
        testArc.setLength(to: -1.0)
        XCTAssertTrue(testArc.length.isEqual(to: 1.0))
        XCTAssertTrue(testArc.endAngle == arc.startAngle)
        
        // Set the arc to an impossible negative length
        testArc = arc
        testArc.setLength(to: -testArc.circumference - 1.0)
        XCTAssertTrue(testArc.length.isEqual(to: 1.0))
        XCTAssertTrue(testArc.endAngle == arc.startAngle)
    }
    
    func testMidpoint() throws {
        let arc = SMArc(radius: 1, startAngle: SMAngle(degrees: 90), endAngle: SMAngle(degrees: 270))
        XCTAssertTrue(arc.midPoint == SMPoint(x: -1, y: 0))
    }
    
    func testPointAtProportion() throws {
        let arc = SMArc(radius: 1, startAngle: SMAngle(degrees: 45), endAngle: SMAngle(degrees: 225))
        XCTAssertTrue(arc.pointAtProportion(0.0) == arc.startPoint)
        XCTAssertTrue(arc.pointAtProportion(0.25) == SMPoint(x: 0, y: 1))
        XCTAssertTrue(arc.pointAtProportion(0.75) == SMPoint(x: -1, y: 0))
        XCTAssertTrue(arc.pointAtProportion(1.0) == arc.endPoint)
        XCTAssertTrue(arc.pointAtProportion(1.25) == SMPoint(x: 0, y: -1))
    }
    
    func testCentralAngle() throws {
        var arc = SMArc(radius: 1.0, startAngle: SMAngle(degrees: 0), endAngle: SMAngle(degrees: 0))
        XCTAssertTrue(arc.centralAngle == SMAngle(degrees: 0))
        arc = SMArc(radius: 1.0, startAngle: SMAngle(degrees: 10), endAngle: SMAngle(degrees: 50))
        XCTAssertTrue(arc.centralAngle == SMAngle(degrees: 40))
        arc = SMArc(radius: 1.0, startAngle: SMAngle(degrees: 350), endAngle: SMAngle(degrees: 10))
        XCTAssertTrue(arc.centralAngle == SMAngle(degrees: 20))
        arc = SMArc(radius: 1.0, startAngle: SMAngle(degrees: 0), endAngle: SMAngle(degrees: 270))
        XCTAssertTrue(arc.centralAngle == SMAngle(degrees: 270))
        arc = SMArc(radius: 1.0, startAngle: SMAngle(degrees: 0), endAngle: SMAngle(degrees: 360))
        XCTAssertTrue(arc.centralAngle == SMAngle(degrees: 0))
        arc = SMArc(radius: 1.0, startAngle: SMAngle(degrees: -90), endAngle: SMAngle(degrees: 90))
        XCTAssertTrue(arc.centralAngle == SMAngle(degrees: 180))
        arc = SMArc(radius: 1.0, startAngle: SMAngle(degrees: -45), endAngle: SMAngle(degrees: 45))
        XCTAssertTrue(arc.centralAngle == SMAngle(degrees: 90))
        arc = SMArc(radius: 1.0, startAngle: SMAngle(degrees: 120), endAngle: SMAngle(degrees: 60))
        XCTAssertTrue(arc.centralAngle == SMAngle(degrees: 300))
        arc = SMArc(radius: 1.0, startAngle: SMAngle(degrees: 720), endAngle: SMAngle(degrees: 1080))
        XCTAssertTrue(arc.centralAngle == SMAngle(degrees: 0))
    }

}
