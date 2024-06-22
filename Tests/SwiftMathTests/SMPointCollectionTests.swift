//
//  SMPointCollectionTests.swift
//  SwiftMathTests
//
//  Created by Andre Pham on 23/6/2024.
//

import XCTest
@testable import SwiftMath

final class SMPointCollectionTests: XCTestCase {

    func testBoundingBox() throws {
        let pointCollection = SMPointCollection(points: SMPoint(x: 2175.0, y: 1250.0), SMPoint(x: 2250.0, y: 1310.0))
        let boundingBox = pointCollection.boundingBox!
        XCTAssertEqual(boundingBox.minX, 2175.0)
        XCTAssertEqual(boundingBox.maxX, 2250.0)
        XCTAssertEqual(boundingBox.minY, 1250.0)
        XCTAssertEqual(boundingBox.maxY, 1310.0)
    }
    
}
