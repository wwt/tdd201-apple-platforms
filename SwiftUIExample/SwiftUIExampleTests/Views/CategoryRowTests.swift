//
//  CategoryRowTests.swift
//  SwiftUIExampleTests
//
//  Created by Zach Frew on 5/21/21.
//

import ViewInspector
import XCTest

@testable import SwiftUIExample

class CategoryRowTests: XCTestCase {
    func testCategoryRow() throws {
        let expectedName = UUID().uuidString
        let expectedItems = try JSONDecoder().decode([Landmark].self, from: landmarksJson)
        let categoryRow = try CategoryRow(name: expectedName, items: expectedItems).inspect()
        let scrollView = try categoryRow.find(ViewType.ScrollView.self)
        let forEach = try scrollView.find(ViewType.ForEach.self)

        XCTAssertEqual(try categoryRow.find(ViewType.Text.self).string(), expectedName)
        XCTAssertEqual(forEach.count, expectedItems.count)

        try forEach.enumerated().forEach { offset, element in
            let navLink = XCTAssertNoThrowAndAssign(try element.find(ViewType.NavigationLink.self))
            let categoryItem = XCTAssertNoThrowAndAssign(try navLink?.labelView().view(CategoryItem.self))
            let landmarkDetail = XCTAssertNoThrowAndAssign(try navLink?.view(LandmarkDetail.self))

            XCTAssertEqual(try categoryItem?.actualView().landmark, expectedItems[offset])
            XCTAssertEqual(try landmarkDetail?.actualView().landmark, expectedItems[offset])
        }
    }
}
