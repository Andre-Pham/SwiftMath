//
//  SMEllipseTests.swift
//  SwiftMath
//
//  Created by Andre Pham on 7/3/2024.
//

import XCTest
@testable import SwiftMath

final class SMEllipseTests: XCTestCase {

    func testCircumference() throws {
        let ellipse = SMEllipse(boundingBox: SMRect(center: SMPoint(), width: 20, height: 10))
        XCTAssertTrue(SM.isEqual(ellipse.circumference, 48.44, precision: 1e-2))
        let empty = SMEllipse(boundingBox: SMRect(minX: 0, maxX: 0, minY: 0, maxY: 0))
        XCTAssertTrue(SM.isZero(empty.circumference))
    }

}
