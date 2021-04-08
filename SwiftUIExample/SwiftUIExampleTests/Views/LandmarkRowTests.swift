//
//  LandmarkRowTests.swift
//  SwiftUIExampleTests
//
//  Created by Richard Gist on 4/8/21.
//

import XCTest
import SwiftUI
import ViewInspector

@testable import SwiftUIExample

class LandmarkRowTests: XCTestCase {
    func testViewHasExpectedViews() throws {
        let expectedLandmark = Landmark.createForTests(id: Int.random(in: 1000...10000),
                                                       name: UUID().uuidString,
                                                       park: UUID().uuidString,
                                                       state: UUID().uuidString,
                                                       description: UUID().uuidString,
                                                       isFavorite: false,
                                                       isFeatured: Bool.random(),
                                                       category: .mountains,
                                                       coordinates: .init(latitude: 1, longitude: 2))
        let landmarkRow = LandmarkRow(landmark: expectedLandmark)

        let image = XCTAssertNoThrowAndAssign(try landmarkRow.inspect().find(ViewType.Image.self))
        XCTAssertEqual(try image?.actualImage(), expectedLandmark.image.resizable())
        XCTAssertEqual(try landmarkRow.inspect().find(ViewType.Text.self).string(), expectedLandmark.name)
        XCTAssertThrowsError(try landmarkRow.inspect().find(ViewType.Image.self, index: 1))
    }

    func testViewHasExpectedViewsWhenIsFavoriteIsFalse() throws {
        let expectedLandmark = Landmark.createForTests(id: Int.random(in: 1000...10000),
                                                       name: UUID().uuidString,
                                                       park: UUID().uuidString,
                                                       state: UUID().uuidString,
                                                       description: UUID().uuidString,
                                                       isFavorite: true,
                                                       isFeatured: Bool.random(),
                                                       category: .mountains,
                                                       coordinates: .init(latitude: 1, longitude: 2))
        let landmarkRow = LandmarkRow(landmark: expectedLandmark)

        let image = XCTAssertNoThrowAndAssign(try landmarkRow.inspect().find(ViewType.Image.self))
        let favoriteImage = XCTAssertNoThrowAndAssign(try landmarkRow.inspect().find(ViewType.Image.self, index: 1))
        XCTAssertEqual(try image?.actualImage(), expectedLandmark.image.resizable())
        XCTAssertEqual(try landmarkRow.inspect().find(ViewType.Text.self).string(), expectedLandmark.name)
        XCTAssertEqual(try favoriteImage?.actualImage(), Image(systemName: "star.fill"))
    }
}
