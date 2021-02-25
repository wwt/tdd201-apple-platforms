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

@testable import SwiftUIExample

class ContentViewTests: XCTestCase {

    func testContentView() throws {
        let exp = ViewHosting.loadView(ContentView(), data: ModelData()).inspection.inspect { (view) in
            let tabView = try view.find(ViewType.TabView.self)

            XCTAssertNoThrow(try tabView.view(CategoryHome.self, 0))
            XCTAssertThrowsError(try tabView.view(LandmarkList.self, 0))
        }
        wait(for: [exp], timeout: 0.1)
    }
}
