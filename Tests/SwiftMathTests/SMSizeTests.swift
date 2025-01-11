//
//  SMSizeTests.swift
//  SwiftMathTests
//
//  Created by Andre Pham on 11/1/2025.
//

import XCTest
import SwiftMath

final class SMSizeTests: XCTestCase {
    
    func testExpandToAspectRatio() throws {
        // Case 1: Width and height same, increase aspect ratio
        var size = SMSize(width: 100, height: 100)
        size.expandToAspectRatio(1.5)
        XCTAssertTrue(size == SMSize(width: 150, height: 100))
        // Case 2: Width and height same, decrease aspect ratio
        size = SMSize(width: 100, height: 100)
        size.expandToAspectRatio(0.5)
        XCTAssertTrue(size == SMSize(width: 100, height: 200))
        // Case 3: Width > height, increase aspect ratio
        size = SMSize(width: 200, height: 100)
        size.expandToAspectRatio(2.5)
        XCTAssertTrue(size == SMSize(width: 250, height: 100))
        // Case 4: Width > height, decrease aspect ratio
        size = SMSize(width: 200, height: 100)
        size.expandToAspectRatio(0.5)
        XCTAssertTrue(size == SMSize(width: 200, height: 400))
        // Case 5: Height > width, increase aspect ratio
        size = SMSize(width: 100, height: 200)
        size.expandToAspectRatio(1.5)
        XCTAssertTrue(size == SMSize(width: 300, height: 200))
        // Case 6: Height > width, decrease aspect ratio
        size = SMSize(width: 100, height: 200)
        size.expandToAspectRatio(0.2)
        XCTAssertTrue(size == SMSize(width: 100, height: 500))
        // Case 7: Aspect ratio doesn't change
        size = SMSize(width: 100, height: 200)
        size.expandToAspectRatio(0.5)
        XCTAssertTrue(size == SMSize(width: 100, height: 200))
    }
    
    func testShrinkToAspectRatio() throws {
        // Case 1: Width and height the same, increase aspect ratio
        var size = SMSize(width: 100, height: 100)
        size.shrinkToAspectRatio(2)
        XCTAssertTrue(size == SMSize(width: 100, height: 50))
        // Case 2: Width and height the same, decrease aspect ratio
        size = SMSize(width: 100, height: 100)
        size.shrinkToAspectRatio(0.5)
        XCTAssertTrue(size == SMSize(width: 50, height: 100))
        // Case 3: Width > height, increase aspect ratio
        size = SMSize(width: 200, height: 100)
        size.shrinkToAspectRatio(2.5)
        XCTAssertTrue(size == SMSize(width: 200, height: 80))
        // Case 4: Width > height, decrease aspect ratio
        size = SMSize(width: 200, height: 100)
        size.shrinkToAspectRatio(1)
        XCTAssertTrue(size == SMSize(width: 100, height: 100))
        // Case 5: Height > width, increase aspect ratio
        size = SMSize(width: 100, height: 200)
        size.shrinkToAspectRatio(1)
        XCTAssertTrue(size == SMSize(width: 100, height: 100))
        // Case 6: Height > width, decrease aspect ratio
        size = SMSize(width: 100, height: 200)
        size.shrinkToAspectRatio(0.25)
        XCTAssertTrue(size == SMSize(width: 50, height: 200))
        // Case 7: Aspect ratio doesn't change
        size = SMSize(width: 100, height: 200)
        size.shrinkToAspectRatio(0.5)
        XCTAssertTrue(size == SMSize(width: 100, height: 200))
    }

    func testAdjustHeightToAspectRatio() throws {
        // Case 1: Width and height the same, increase aspect ratio
        var size = SMSize(width: 100, height: 100)
        size.adjustHeightToAspectRatio(2)
        XCTAssertTrue(size == SMSize(width: 100, height: 50))
        // Case 2: Width and height the same, decrease aspect ratio
        size = SMSize(width: 100, height: 100)
        size.adjustHeightToAspectRatio(0.5)
        XCTAssertTrue(size == SMSize(width: 100, height: 200))
        // Case 3: Width > height, increase aspect ratio
        size = SMSize(width: 200, height: 100)
        size.adjustHeightToAspectRatio(2.5)
        XCTAssertTrue(size == SMSize(width: 200, height: 80))
        // Case 4: Width > height, decrease aspect ratio
        size = SMSize(width: 200, height: 100)
        size.adjustHeightToAspectRatio(0.5)
        XCTAssertTrue(size == SMSize(width: 200, height: 400))
        // Case 5: Height > width, increase aspect ratio
        size = SMSize(width: 100, height: 200)
        size.adjustHeightToAspectRatio(2)
        XCTAssertTrue(size == SMSize(width: 100, height: 50))
        // Case 6: Height > width, decrease aspect ratio
        size = SMSize(width: 100, height: 200)
        size.adjustHeightToAspectRatio(0.2)
        XCTAssertTrue(size == SMSize(width: 100, height: 500))
        // Case 7: Aspect ratio doesn't change
        size = SMSize(width: 100, height: 200)
        size.adjustHeightToAspectRatio(0.5)
        XCTAssertTrue(size == SMSize(width: 100, height: 200))
    }

    func testAdjustWidthToAspectRatio() throws {
        // Case 1: Width and height the same, increase aspect ratio
        var size = SMSize(width: 100, height: 100)
        size.adjustWidthToAspectRatio(2)
        XCTAssertTrue(size == SMSize(width: 200, height: 100))
        // Case 2: Width and height the same, decrease aspect ratio
        size = SMSize(width: 100, height: 100)
        size.adjustWidthToAspectRatio(0.5)
        XCTAssertTrue(size == SMSize(width: 50, height: 100))
        // Case 3: Width > height, increase aspect ratio
        size = SMSize(width: 200, height: 100)
        size.adjustWidthToAspectRatio(2.5)
        XCTAssertTrue(size == SMSize(width: 250, height: 100))
        // Case 4: Width > height, decrease aspect ratio
        size = SMSize(width: 200, height: 100)
        size.adjustWidthToAspectRatio(0.5)
        XCTAssertTrue(size == SMSize(width: 50, height: 100))
        // Case 5: Height > width, increase aspect ratio
        size = SMSize(width: 100, height: 200)
        size.adjustWidthToAspectRatio(1.5)
        XCTAssertTrue(size == SMSize(width: 300, height: 200))
        // Case 6: Height > width, decrease aspect ratio
        size = SMSize(width: 100, height: 200)
        size.adjustWidthToAspectRatio(0.2)
        XCTAssertTrue(size == SMSize(width: 40, height: 200))
        // Case 7: Aspect ratio doesn't change
        size = SMSize(width: 100, height: 200)
        size.adjustWidthToAspectRatio(0.5)
        XCTAssertTrue(size == SMSize(width: 100, height: 200))
    }

}
