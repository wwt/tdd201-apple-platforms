//
//  CategoryRowTests.swift
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

class CategoryRowTests: XCTestCase {
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        let landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)
        let view = CategoryRow(categoryName: landmarks[0].category.rawValue,
                               items: Array(landmarks.prefix(4)))
        assertSnapshot(matching: view, as: .image(precision: 0.99, layout: .device(config: .iPhoneXsMax)))
    }

    func testCategoryRowDisplaysCategoryNameWithLandmarks() throws {
        let landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson).filter { $0.category == .mountains }
        let categoryRow = CategoryRow(categoryName: "Mountains", items: landmarks)
        let categoryName = try categoryRow.inspect().find(ViewType.Text.self, index: 0)

        XCTAssertEqual(try categoryName.string(), "Mountains")
        XCTAssertEqual(try categoryName.attributes().font(), .headline)

        XCTAssertEqual(try categoryRow.inspect().find(ViewType.ForEach.self).count, landmarks.count)
        try categoryRow.inspect().find(ViewType.ForEach.self).enumerated().forEach {
            let navLink = try $0.element.find(ViewType.NavigationLink.self)
            let landmarkDetail = try navLink.view(LandmarkDetail.self)
            let categoryItem = try navLink.labelView().find(CategoryItem.self)
            XCTAssertEqual(try landmarkDetail.actualView().landmark, landmarks[$0.offset])
            XCTAssertEqual(try categoryItem.actualView().landmark, landmarks[$0.offset])
        }
    }
}
