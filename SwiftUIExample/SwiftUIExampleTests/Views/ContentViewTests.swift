//
//  ContentViewTests.swift
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

class ContentViewTests: XCTestCase {
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        let view = CategoryHome().environmentObject(ModelData())
        assertSnapshot(matching: view, as: .image(precision: 0.99))
    }

    func testContentView() throws {
        let exp = ViewHosting.loadView(ContentView(), data: ModelData()).inspection.inspect { (view) in
            let tabView = try view.find(ViewType.TabView.self)

            XCTAssertNoThrow(try tabView.view(CategoryHome.self, 0))
            XCTAssertThrowsError(try tabView.view(LandmarkList.self, 0))
        }
        wait(for: [exp], timeout: 0.1)
    }
}
