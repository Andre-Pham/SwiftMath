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
    
    func testDuplicatedPoints() throws {
        var points = [
            SMPoint(x: 0.0, y: 0.0),
            SMPoint(x: 90.0, y: 95.8),
            SMPoint(x: 96.82, y: -51.09),
            SMPoint(x: 49.571, y: -19.249),
            SMPoint(x: -64.7999, y: 36.4093),
            SMPoint(x: -5.57758, y: -42.25322),
            SMPoint(x: -66.896551, y: -65.278408),
            SMPoint(x: -63.5052422, y: 81.693685),
            SMPoint(x: 3.75360364, y: 1.84417909),
            SMPoint(x: -90.283988151, y: 36.610757357),
            SMPoint(x: 72.6858175262, y: 17.4106647056),
            SMPoint(x: 43.2616052346, y: -20.87526571607),
            SMPoint(x: -19.919247080822, y: 43.233714498859),
            SMPoint(x: 95.7568438744588, y: 52.6663525558165),
            SMPoint(x: -44.71100891416826, y: -88.97333259067834),
            SMPoint(x: -28.413917466314274, y: 14.371958642892537),
            SMPoint(x: 74.9938124789744, y: 5.639810672013866),
            SMPoint(x: 41.79159031512023, y: 39.674099351214096),
            SMPoint(x: 92.50998741620441, y: -93.54874779236873),
            SMPoint(x: 58.68100872673165, y: 80.92686671802932)
        ]
        points.append(points[3].clone())
        points.append(points[5].clone())
        points.append(points[7].clone())
        points.append(points[9].clone())
        for _ in 0..<3 {
            points.append(points[19].clone())
        }
        let duplicates = SMPointCollection(points: points).duplicatedPoints()
        XCTAssertEqual(duplicates.count, 5)
        XCTAssertEqual(duplicates[points[3]], 1)
        XCTAssertEqual(duplicates[points[5]], 1)
        XCTAssertEqual(duplicates[points[7]], 1)
        XCTAssertEqual(duplicates[points[9]], 1)
        XCTAssertEqual(duplicates[points[19]], 3)
    }
    
    func testCountDuplicatedPoints() throws {
        var points = [
            SMPoint(x: 0.0, y: 0.0),
            SMPoint(x: 90.0, y: 95.8),
            SMPoint(x: 96.82, y: -51.09),
            SMPoint(x: 49.571, y: -19.249),
            SMPoint(x: -64.7999, y: 36.4093),
            SMPoint(x: -5.57758, y: -42.25322),
            SMPoint(x: -66.896551, y: -65.278408),
            SMPoint(x: -63.5052422, y: 81.693685),
            SMPoint(x: 3.75360364, y: 1.84417909),
            SMPoint(x: -90.283988151, y: 36.610757357),
            SMPoint(x: 72.6858175262, y: 17.4106647056),
            SMPoint(x: 43.2616052346, y: -20.87526571607),
            SMPoint(x: -19.919247080822, y: 43.233714498859),
            SMPoint(x: 95.7568438744588, y: 52.6663525558165),
            SMPoint(x: -44.71100891416826, y: -88.97333259067834),
            SMPoint(x: -28.413917466314274, y: 14.371958642892537),
            SMPoint(x: 74.9938124789744, y: 5.639810672013866),
            SMPoint(x: 41.79159031512023, y: 39.674099351214096),
            SMPoint(x: 92.50998741620441, y: -93.54874779236873),
            SMPoint(x: 58.68100872673165, y: 80.92686671802932)
        ]
        points.append(points[3].clone())
        points.append(points[5].clone())
        points.append(points[7].clone())
        points.append(points[9].clone())
        for _ in 0..<3 {
            points.append(points[19].clone())
        }
        let duplicateCount = SMPointCollection(points: points).countDuplicatedPoints()
        XCTAssertEqual(duplicateCount, 7)
    }
    
}
