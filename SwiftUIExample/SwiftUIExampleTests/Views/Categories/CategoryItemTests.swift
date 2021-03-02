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
        let landmark = try JSONDecoder().decode([Landmark].self, from: Self.landmark).first!
        let view = CategoryItem(landmark: landmark)
        assertSnapshot(matching: view, as: .image(precision: 0.99))
    }

    func testCategoryItemDisplaysCategoryNameWithLandmarks() throws {
        let landmark = try JSONDecoder().decode([Landmark].self, from: Self.landmark).first!
        let categoryItem = CategoryItem(landmark: landmark)
        let vStack = try categoryItem.inspect().vStack()
        let name = try vStack.find(ViewType.Text.self)
        let image = try vStack.find(ViewType.Image.self)

        XCTAssertEqual(try name.string(), "Chilkoot Trail")
        XCTAssertEqual(try name.attributes().font(), .caption)
        XCTAssertEqual(try image.actualImage(), landmark.image.renderingMode(.original).resizable())
    }
}

extension CategoryItemTests {
    // swiftlint:disable line_length
    static let landmark = Data("""
        [{
            "name": "Chilkoot Trail",
            "category": "Mountains",
            "city": "Skagway",
            "state": "Alaska",
            "id": 1003,
            "isFeatured": false,
            "isFavorite": true,
            "park": "Klondike Gold Rush National Historical Park",
            "coordinates": {
                "longitude": -135.334571,
                "latitude": 59.560551
            },
            "description": "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus, cras ante etiam sit conubia elit tempus accumsan libero, mattis per erat habitasse cubilia ligula penatibus curae. Sagittis lorem augue arcu blandit libero molestie non ullamcorper, finibus imperdiet iaculis ad quam per luctus neque, ligula curae mauris parturient diam auctor eleifend laoreet ridiculus, hendrerit adipiscing sociosqu pretium nec velit aliquam. Inceptos egestas maecenas imperdiet eget id donec nisl curae congue, massa tortor vivamus ridiculus integer porta ultrices venenatis aliquet, curabitur et posuere blandit magnis dictum auctor lacinia, eleifend dolor in ornare vulputate ipsum morbi felis. Faucibus cursus malesuada orci ultrices diam nisl taciti torquent, tempor eros suspendisse euismod condimentum dis velit mi tristique, a quis etiam dignissim dictum porttitor lobortis ad fermentum, sapien consectetur dui dolor purus elit pharetra. Interdum mattis sapien ac orci vestibulum vulputate laoreet proin hac, maecenas mollis ridiculus morbi praesent cubilia vitae ligula vel, sem semper volutpat curae mauris justo nisl luctus, non eros primis ultrices nascetur erat varius integer.",
            "imageName": "chilkoottrail"
        }]
    """.utf8)
    // swiftlint:enable line_length
}
