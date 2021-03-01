//
//  GraphCapsuleTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/23/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector
import SnapshotTesting

@testable import SwiftUIExample

class GraphCapsuleTests: XCTestCase {

    func testUILooksAsExpected() throws {
        let view = GraphCapsule(index: 0, height: 150, range: 10..<50, overallRange: 0..<100)
            .colorMultiply(.blue)
        throw XCTSkip()
        assertSnapshot(matching: view, as: .image(precision: 0.99))
        XCTFail("Snapshot not working as expected")
    }

    func testGraphCapsule() throws {
        let graphCapsule = GraphCapsule(index: 0, height: 1.0, range: 1..<20, overallRange: 3..<23)

        let capsule = try graphCapsule.inspect().shape()

        XCTAssertEqual(try capsule.fixedHeight(), 0.95)
    }
}
