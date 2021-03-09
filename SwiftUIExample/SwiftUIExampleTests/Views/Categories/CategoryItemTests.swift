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
import SnapshotTesting

@testable import SwiftUIExample

extension CategoryItem: Inspectable { }

class CategoryItemTests: XCTestCase {
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        let landmark = Landmark.createForTests(id: 1003,
                                               name: "Chilkoot Trail",
                                               park: "klondike Gold Rush National Historical Park",
                                               state: "Alaska",
                                               description: "I'm a little teapot",
                                               isFavorite: true,
                                               isFeatured: false,
                                               category: .mountains,
                                               coordinates: .init(latitude: 59.560551, longitude: -135.334571),
                                               imageName: "chilkoottrail")
        let view = CategoryItem(landmark: landmark)
        assertSnapshot(matching: view, as: .image)
    }

    func testCategoryItemDisplaysCategoryNameWithLandmarks() throws {
        let landmark = Landmark.createForTests(id: 1003,
                                               name: "Chilkoot Trail",
                                               park: "klondike Gold Rush National Historical Park",
                                               state: "Alaska",
                                               description: "I'm a little teapot",
                                               isFavorite: true,
                                               isFeatured: false,
                                               category: .mountains,
                                               coordinates: .init(latitude: 59.560551, longitude: -135.334571))
        let categoryItem = CategoryItem(landmark: landmark)
        let vStack = try categoryItem.inspect().vStack()
        let name = try vStack.find(ViewType.Text.self)
        let image = try vStack.find(ViewType.Image.self)

        XCTAssertEqual(try name.string(), "Chilkoot Trail")
        XCTAssertEqual(try name.attributes().font(), .caption)
        XCTAssertEqual(try image.actualImage(), landmark.image.renderingMode(.original).resizable())
    }
}
