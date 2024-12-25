//
//  SMPointTests.swift
//  SwiftMathTests
//
//  Created by Andre Pham on 18/7/2023.
//

import XCTest
@testable import SwiftMath

final class SMPointTests: XCTestCase {

    func testRotate() throws {
        var point = SMPoint(x: 1.0, y: 0.0)
        point.rotate(around: SMPoint(), by: SMAngle(degrees: 90.0))
        XCTAssertTrue(point.x.isEqual(to: 0.0))
        XCTAssertTrue(point.y.isEqual(to: 1.0))
        point.rotate(around: SMPoint(), by: SMAngle(degrees: -270.0))
        XCTAssertTrue(point.x.isEqual(to: -1.0))
        XCTAssertTrue(point.y.isEqual(to: 0.0))
    }

}
