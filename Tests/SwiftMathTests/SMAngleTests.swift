//
//  SMAngleTests.swift
//  SwiftMathTests
//
//  Created by Andre Pham on 18/7/2023.
//

import XCTest
import SwiftMath

final class SMAngleTests: XCTestCase {

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
        let angle = SMAngle(degrees: -45.0)
        XCTAssertEqual(angle.normalized.degrees, 315.0)
    }

}
