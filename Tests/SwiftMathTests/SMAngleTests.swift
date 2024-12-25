//
//  SMAngleTests.swift
//  SwiftMathTests
//
//  Created by Andre Pham on 18/7/2023.
//

import XCTest
@testable import SwiftMath

final class SMAngleTests: XCTestCase {
    
    func testRadians() throws {
        let angle = SMAngle(degrees: 90)
        XCTAssertTrue(angle.radians.isEqual(to: .pi / 2.0))
    }
    
    func testDegrees() throws {
        let angle = SMAngle(radians: .pi / 2.0)
        XCTAssertTrue(angle.degrees.isEqual(to: 90.0))
    }

    func testThreePointConstructor() throws {
        let angle90 = SMAngle(
            point1: SMPoint(x: 1.0, y: 0.0),
            vertex: SMPoint(),
            point2: SMPoint(x: 0.0, y: 1.0)
        )
        XCTAssertEqual(angle90.degrees, 90.0)
        let angle270 = SMAngle(
            point1: SMPoint(x: -1.0, y: 0.0),
            vertex: SMPoint(),
            point2: SMPoint(x: 0.0, y: 1.0)
        )
        XCTAssertEqual(angle270.degrees, 270.0)
        let angle0 = SMAngle(point1: SMPoint(), vertex: SMPoint(), point2: SMPoint())
        XCTAssertEqual(angle0.degrees, 0.0)
    }
    
    func testNormalization() throws {
        var angle = SMAngle(degrees: -45.0)
        XCTAssertEqual(angle.normalized.degrees, 315.0)
        angle.normalize()
        XCTAssertEqual(angle.degrees, 315.0)
    }
    
    func testGradient() throws {
        let angle90 = SMAngle(degrees: 90)
        XCTAssertEqual(angle90.gradient, nil)
        let angle0 = SMAngle()
        XCTAssertTrue(angle0.gradient!.isZero())
        let angle45 = SMAngle(degrees: 45)
        XCTAssertTrue(angle45.gradient!.isEqual(to: 1.0))
    }

}
