//
//  HikeBadgeTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/25/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector
import SnapshotTesting

@testable import SwiftUIExample

class HikeBadgeTests: XCTestCase {
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        let view = HikeBadge(name: "name")
        assertSnapshot(matching: view, as: .image)
    }

    func testHikeBadge() throws {
        let expectedName = "Charley"
        let view = HikeBadge(name: expectedName)

        XCTAssertNoThrow(try view.inspect().find(Badge.self))
        XCTAssertEqual(try view.inspect().find(ViewType.Text.self).string(), expectedName)
    }

}
