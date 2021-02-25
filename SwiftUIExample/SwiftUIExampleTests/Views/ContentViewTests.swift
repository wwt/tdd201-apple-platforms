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

extension ContentView: Inspectable { }

class ContentViewTests: XCTestCase {

    func testContentView() throws {
        let exp = ViewHosting.loadView(ContentView(), data: ModelData()).inspection.inspect { (view) in
            let tabView = try view.find(ViewType.TabView.self)
            XCTAssertNoThrow(try tabView.find(CategoryHome.self))
            XCTAssertNoThrow(try tabView.find(LandmarkList.self))

        }
        wait(for: [exp], timeout: 0.1)
    }

}
