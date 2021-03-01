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

    func testUILooksAsExpected() throws {
        let view = Badge()
        assertSnapshot(matching: view, as: .image(precision: 0.99))
    }
}
