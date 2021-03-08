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
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        UIApplication.shared.windows.first?.becomeKey()
        let view = GraphCapsule(index: 0, height: 150, range: 10..<50, overallRange: 0..<100)
        assertSnapshot(matching: view.colorMultiply(.blue), as: .image(drawHierarchyInKeyWindow: true,
                                                                       precision: 0.99,
                                                                       layout: .fixed(width: 400, height: view.height * view.heightRatio + 20)))
    }

    #warning("Need to test height ratio and offset ratio")

    func testGraphCapsule() throws {
        let graphCapsule = GraphCapsule(index: 0, height: 1.0, range: 1..<20, overallRange: 3..<23)

        XCTAssertEqual(try graphCapsule.inspect().shape().fixedHeight(), 0.95)
        XCTAssertEqual(try graphCapsule.inspect().shape().offset(), CGSize(width: 0.0, height: 0.1))
    }
}
