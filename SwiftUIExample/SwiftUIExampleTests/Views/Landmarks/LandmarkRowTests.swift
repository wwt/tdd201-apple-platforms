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
    func testFavoriteLandmarkRowDisplaysLandmarkWithStar() throws {
        let expectedLandmark = Landmark.createForTests(id: 1003,
                                               name: "Chilkoot Trail",
                                               park: "klondike Gold Rush National Historical Park",
                                               state: "Alaska",
                                               description: "I'm a little teapot",
                                               isFavorite: true,
                                               isFeatured: false,
                                               category: .mountains,
                                               coordinates: .init(latitude: 59.560551, longitude: -135.334571),
                                               imageName: "chilkoottrail")
        let landmarkRow = LandmarkRow(landmark: expectedLandmark)

        XCTAssertEqual(try landmarkRow.inspect().hStack().image(0).actualImage(), expectedLandmark.image.resizable())
        XCTAssertEqual(try landmarkRow.inspect().hStack().text(1).string(), expectedLandmark.name)
        XCTAssertEqual(try landmarkRow.inspect().hStack().image(3).actualImage(), Image(systemName: "star.fill"))
        XCTAssertEqual(try landmarkRow.inspect().hStack().image(3).foregroundColor(), .yellow)
    }

    func testNonFavoritedLandmarkRowDisplaysLandmarkWithoutStar() throws {
        let expectedLandmark = Landmark.createForTests(id: 1003,
                                               name: "Chilkoot Trail",
                                               park: "klondike Gold Rush National Historical Park",
                                               state: "Alaska",
                                               description: "I'm a little teapot",
                                               isFavorite: false,
                                               isFeatured: false,
                                               category: .mountains,
                                               coordinates: .init(latitude: 59.560551, longitude: -135.334571),
                                               imageName: "chilkoottrail")
        let landmarkRow = LandmarkRow(landmark: expectedLandmark)

        XCTAssertEqual(try landmarkRow.inspect().hStack().image(0).actualImage(), expectedLandmark.image.resizable())
        XCTAssertEqual(try landmarkRow.inspect().hStack().text(1).string(), expectedLandmark.name)
        XCTAssertThrowsError(try landmarkRow.inspect().hStack().image(3).actualImage(), "Expected to not find favorite image")
    }
}
