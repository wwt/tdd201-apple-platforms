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
        let view = CategoryHome().environmentObject(ModelData())
        assertSnapshot(matching: view, as: .image(precision: 0.99))
    }

    func testCategoryHomeHasNavigationView() throws {
        let exp = ViewHosting.loadView(CategoryHome(), data: ModelData()).inspection.inspect { (view) in
            XCTAssertNoThrow(try view.navigationView())
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testCategoryHomeDoesNotCrashWhenNoLandmarks() throws {
        let modelData = ModelData()
        modelData.landmarks = []

        let exp = ViewHosting.loadView(CategoryHome(), data: modelData).inspection.inspect { (view) in
            XCTAssertThrowsError(try view.navigationView().list(0).image(0))
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testCategoryHomeDisplaysFeaturedLandmarks() throws {
        let file = Bundle.main.url(forResource: "landmarkData", withExtension: "json")!
        let data = try Data(contentsOf: file)
        let modelData = ModelData()
        modelData.landmarks = try JSONDecoder().decode([Landmark].self, from: data)

        let exp = ViewHosting.loadView(CategoryHome(), data: modelData).inspection.inspect { (view) in
            XCTAssertEqual(try view.navigationView().list(0).image(0).actualImage(), modelData.features[0].image.resizable())
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testCategoryHomeDisplaysCategoriesOfLandmarks() throws {
        let file = Bundle.main.url(forResource: "landmarkData", withExtension: "json")!
        let data = try Data(contentsOf: file)
        let modelData = ModelData()
        modelData.landmarks = try JSONDecoder().decode([Landmark].self, from: data)

        let exp = ViewHosting.loadView(CategoryHome(), data: modelData).inspection.inspect { (view) in
            let list = try view.navigationView().list(0)
            try list.find(ViewType.ForEach.self).enumerated().forEach {
                let row = try $0.element.find(CategoryRow.self).actualView()
                let expectedKey = modelData.categories.keys.sorted()[$0.offset]
                XCTAssertEqual(row.categoryName, expectedKey)
                XCTAssertEqual(row.items, modelData.categories[expectedKey])
            }
        }

        wait(for: [exp], timeout: 0.1)
    }
}
