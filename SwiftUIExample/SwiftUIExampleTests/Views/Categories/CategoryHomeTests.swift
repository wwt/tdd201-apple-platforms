//
//  CategoryHomeTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/19/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector
import SnapshotTesting

@testable import SwiftUIExample

class CategoryHomeTests: XCTestCase {
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)

        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let view = CategoryHome().environmentObject(appModel)
        assertSnapshot(matching: view, as: .image)
    }

    func testCategoryHomeHasNavigationView() throws {
        let exp = ViewHosting.loadView(CategoryHome(), data: AppModel()).inspection.inspect { (view) in
            XCTAssertNoThrow(try view.navigationView())
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testCategoryHomeDoesNotCrashWhenNoLandmarks() throws {
        let appModel = AppModel()
        appModel.landmarks = []

        let exp = ViewHosting.loadView(CategoryHome(), data: appModel).inspection.inspect { (view) in
            XCTAssertThrowsError(try view.navigationView().list(0).image(0))
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testCategoryHomeDisplaysFeaturedLandmarks() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let exp = ViewHosting.loadView(CategoryHome(), data: appModel).inspection.inspect { (view) in
            XCTAssertEqual(try view.navigationView().list(0).image(0).actualImage(), appModel.features[0].image.resizable())
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testCategoryHomeDisplaysCategoriesOfLandmarks() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let exp = ViewHosting.loadView(CategoryHome(), data: appModel).inspection.inspect { (view) in
            let list = try view.navigationView().list(0)
            try list.find(ViewType.ForEach.self).enumerated().forEach {
                let row = try $0.element.find(CategoryRow.self).actualView()
                let expectedKey = appModel.categories.keys.sorted()[$0.offset]
                XCTAssertEqual(row.categoryName, expectedKey)
                XCTAssertEqual(row.items, appModel.categories[expectedKey])
            }
        }

        wait(for: [exp], timeout: 0.1)
    }
}
