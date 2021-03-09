//
//  BadgeBackgroundTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 3/1/21.
//

import Foundation
import XCTest
import SwiftUI
import SnapshotTesting

@testable import SwiftUIExample

class BadgeBackgroundTests: XCTestCase {
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        assertSnapshot(matching: BadgeBackground(), as: .image)
    }
}
