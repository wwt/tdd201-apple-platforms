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

    func testUILooksAsExpected() throws {
        let view = RotatedBadgeSymbol(angle: .degrees(90))
        assertSnapshot(matching: view, as: .image(precision: 0.99))
        throw XCTSkip()
        XCTFail("Snapshot not working as expected")
    }
}
