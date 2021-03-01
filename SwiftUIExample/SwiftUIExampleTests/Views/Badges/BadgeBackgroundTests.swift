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

    func testUILooksAsExpected() throws {
        let view = BadgeBackground()
        assertSnapshot(matching: view, as: .image(precision: 0.99))
    }
}
