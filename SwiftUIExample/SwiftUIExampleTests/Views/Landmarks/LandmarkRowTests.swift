//
//  LandmarkRowTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/22/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector

@testable import SwiftUIExample

class LandmarkRowTests: XCTestCase {

    override func setUpWithError() throws {

    }

    func testFavoriteLandmarkRowDisplaysLandmarkWithStar() throws {
        var expectedLandmark = try JSONDecoder().decode([Landmark].self, from: Self.landmark).first!
        expectedLandmark.isFavorite = true
        let landmarkRow = LandmarkRow(landmark: expectedLandmark)

        XCTAssertEqual(try landmarkRow.inspect().hStack().image(0).actualImage(), expectedLandmark.image.resizable())
        XCTAssertEqual(try landmarkRow.inspect().hStack().text(1).string(), expectedLandmark.name)
        XCTAssertEqual(try landmarkRow.inspect().hStack().image(3).actualImage(), Image(systemName: "star.fill"))
        XCTAssertEqual(try landmarkRow.inspect().hStack().image(3).foregroundColor(), .yellow)
    }

    func testNonFavoritedLandmarkRowDisplaysLandmarkWithoutStar() throws {
        var expectedLandmark = try JSONDecoder().decode([Landmark].self, from: Self.landmark).first!
        expectedLandmark.isFavorite = false
        let landmarkRow = LandmarkRow(landmark: expectedLandmark)

        XCTAssertEqual(try landmarkRow.inspect().hStack().image(0).actualImage(), expectedLandmark.image.resizable())
        XCTAssertEqual(try landmarkRow.inspect().hStack().text(1).string(), expectedLandmark.name)
        XCTAssertThrowsError(try landmarkRow.inspect().hStack().image(3).actualImage(), "Expected to not find favorite image")
    }
}

extension LandmarkRowTests {
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
