//
//  CategoryItemTests.swift
//  SwiftUIExampleTests
//
//  Created by Zach Frew on 5/21/21.
//

import ViewInspector
import XCTest

@testable import SwiftUIExample

class CategoryItemTests: XCTestCase {
    func testCategoryItem() throws {
        let expectedLandmark = try JSONDecoder().decode([Landmark].self, from: landmarksJson).randomElement()!
        let categoryItem = try CategoryItem(landmark: expectedLandmark).inspect()

        XCTAssertEqual(try categoryItem.find(ViewType.Text.self).string(), expectedLandmark.name)
        XCTAssertEqual(try categoryItem.find(ViewType.Image.self).actualImage(), expectedLandmark.image.renderingMode(.original).resizable())
    }
}
