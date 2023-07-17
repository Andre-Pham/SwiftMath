//
//  SMPointTests.swift
//  SwiftMathTests
//
//  Created by Andre Pham on 18/7/2023.
//

import XCTest
import SwiftMath

final class SMPointTests: XCTestCase {

    func testRotate() throws {
        let point = SMPoint(x: 1.0, y: 0.0)
        point.rotate(around: SMPoint(), by: SMAngle(degrees: 90.0))
        XCTAssertTrue(SM.isEqual(point.x, 0.0))
        XCTAssertTrue(SM.isEqual(point.y, 1.0))
        point.rotate(around: SMPoint(), by: SMAngle(degrees: -270.0))
        XCTAssertTrue(SM.isEqual(point.x, -1.0))
        XCTAssertTrue(SM.isEqual(point.y, 0.0))
    }

}
