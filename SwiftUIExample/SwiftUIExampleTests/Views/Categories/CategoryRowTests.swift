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

    func testUILooksAsExpected() throws {
        let landmarks = ModelData().landmarks
        let view = CategoryRow(categoryName: landmarks[0].category.rawValue,
                               items: Array(landmarks.prefix(4)))
        throw XCTSkip()
        assertSnapshot(matching: view, as: .image(precision: 0.99), record: true)
        XCTFail("Snapshot not working as expected")
    }

    func testCategoryRowDisplaysCategoryNameWithLandmarks() throws {
        let landmarksData =  try JSONDecoder().decode([Landmark].self, from: Self.mountainLandmarks)
        let categoryRow = CategoryRow(categoryName: "Mountains", items: landmarksData)
        let categoryName = try categoryRow.inspect().find(ViewType.Text.self, index: 0)

        XCTAssertEqual(try categoryName.string(), "Mountains")
        XCTAssertEqual(try categoryName.attributes().font(), .headline)

        XCTAssertEqual(try categoryRow.inspect().find(ViewType.ForEach.self).count, landmarksData.count)
        try categoryRow.inspect().find(ViewType.ForEach.self).enumerated().forEach {
            let navLink = try $0.element.find(ViewType.NavigationLink.self)
            let landmarkDetail = try navLink.view(LandmarkDetail.self)
            let categoryItem = try navLink.labelView().find(CategoryItem.self)
            XCTAssertEqual(try landmarkDetail.actualView().landmark, landmarksData[$0.offset])
            XCTAssertEqual(try categoryItem.actualView().landmark, landmarksData[$0.offset])
        }
    }
}

#warning("maybe don't do this")
extension CategoryRowTests {
    // swiftlint:disable line_length
    static let mountainLandmarks = Data("""
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
        },
        {
            "name": "Lake McDonald",
            "category": "Mountains",
            "city": "West Glacier",
            "state": "Montana",
            "id": 1006,
            "isFeatured": false,
            "isFavorite": false,
            "park": "Glacier National Park",
            "coordinates": {
                "longitude": -113.934831,
                "latitude": 48.56002
            },
            "description": "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus, cras ante etiam sit conubia elit tempus accumsan libero, mattis per erat habitasse cubilia ligula penatibus curae. Sagittis lorem augue arcu blandit libero molestie non ullamcorper, finibus imperdiet iaculis ad quam per luctus neque, ligula curae mauris parturient diam auctor eleifend laoreet ridiculus, hendrerit adipiscing sociosqu pretium nec velit aliquam. Inceptos egestas maecenas imperdiet eget id donec nisl curae congue, massa tortor vivamus ridiculus integer porta ultrices venenatis aliquet, curabitur et posuere blandit magnis dictum auctor lacinia, eleifend dolor in ornare vulputate ipsum morbi felis. Faucibus cursus malesuada orci ultrices diam nisl taciti torquent, tempor eros suspendisse euismod condimentum dis velit mi tristique, a quis etiam dignissim dictum porttitor lobortis ad fermentum, sapien consectetur dui dolor purus elit pharetra. Interdum mattis sapien ac orci vestibulum vulputate laoreet proin hac, maecenas mollis ridiculus morbi praesent cubilia vitae ligula vel, sem semper volutpat curae mauris justo nisl luctus, non eros primis ultrices nascetur erat varius integer.",
            "imageName": "lakemcdonald"
        },
        {
            "name": "Icy Bay",
            "category": "Mountains",
            "city": "Icy Bay",
            "state": "Alaska",
            "id": 1008,
            "isFeatured": false,
            "isFavorite": false,
            "park": "Wrangell-St. Elias National Park and Preserve",
            "coordinates": {
                "longitude": -141.518167,
                "latitude": 60.089917
            },
            "description": "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus, cras ante etiam sit conubia elit tempus accumsan libero, mattis per erat habitasse cubilia ligula penatibus curae. Sagittis lorem augue arcu blandit libero molestie non ullamcorper, finibus imperdiet iaculis ad quam per luctus neque, ligula curae mauris parturient diam auctor eleifend laoreet ridiculus, hendrerit adipiscing sociosqu pretium nec velit aliquam. Inceptos egestas maecenas imperdiet eget id donec nisl curae congue, massa tortor vivamus ridiculus integer porta ultrices venenatis aliquet, curabitur et posuere blandit magnis dictum auctor lacinia, eleifend dolor in ornare vulputate ipsum morbi felis. Faucibus cursus malesuada orci ultrices diam nisl taciti torquent, tempor eros suspendisse euismod condimentum dis velit mi tristique, a quis etiam dignissim dictum porttitor lobortis ad fermentum, sapien consectetur dui dolor purus elit pharetra. Interdum mattis sapien ac orci vestibulum vulputate laoreet proin hac, maecenas mollis ridiculus morbi praesent cubilia vitae ligula vel, sem semper volutpat curae mauris justo nisl luctus, non eros primis ultrices nascetur erat varius integer.",
            "imageName": "icybay"
        }]
    """.utf8)
    // swiftlint:enable line_length
}
