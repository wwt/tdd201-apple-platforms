//
//  CategoryItemTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/19/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector

@testable import SwiftUIExample

extension CategoryItem: Inspectable { }

class CategoryItemTests: XCTestCase {
    func testCategoryItemDisplaysCategoryNameWithLandmarks() throws {
        let imageName = "silversalmoncreek"
        let expectedImage = Image(imageName)
        let landmark = Landmark.createForTests(id: 1003,
                                               name: "Chilkoot Trail",
                                               park: "klondike Gold Rush National Historical Park",
                                               state: "Alaska",
                                               description: "I'm a little teapot",
                                               isFavorite: true,
                                               isFeatured: false,
                                               category: .mountains,
                                               coordinates: .init(latitude: 59.560551, longitude: -135.334571),
                                               imageName: imageName)
        let categoryItem = CategoryItem(landmark: landmark)
        let vStack = try categoryItem.inspect().vStack()
        let name = try vStack.find(ViewType.Text.self)
        let image = try vStack.find(ViewType.Image.self)

        XCTAssertEqual(try name.string(), "Chilkoot Trail")
        XCTAssertEqual(try name.attributes().font(), .caption)
        XCTAssertEqual(try image.actualImage(), expectedImage.renderingMode(.original).resizable())
    }
}
