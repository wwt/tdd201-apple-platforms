//
//  BadgeTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 3/1/21.
//

import Foundation
import XCTest
import SwiftUI
import SnapshotTesting

@testable import SwiftUIExample

class BadgeTests: XCTestCase {
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        let view = Badge()
        assertSnapshot(matching: view, as: .image(precision: 0.99))
    }
}
