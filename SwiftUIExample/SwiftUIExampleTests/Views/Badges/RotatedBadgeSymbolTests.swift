//
//  RotatedBadgeSymbolTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 3/1/21.
//

import Foundation
import XCTest
import SwiftUI
import SnapshotTesting

@testable import SwiftUIExample

class RotatedBadgeSymbolTests: XCTestCase {
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        let view = RotatedBadgeSymbol(angle: .degrees(5))
        assertSnapshot(matching: view, as: .image(precision: 0.99, layout: .fixed(width: 400, height: 400)))
    }
}
