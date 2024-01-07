//
//  SMAngleTests.swift
//  SwiftMathTests
//
//  Created by Andre Pham on 7/1/2024.
//

import XCTest
import SwiftMath

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

}
