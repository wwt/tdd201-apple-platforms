//
//  LandmarkRowTest.swift
//  SwiftUIExampleTests
//
//  Created by Zach Frew on 5/21/21.
//

import Fakery
import SwiftUI
import ViewInspector
import XCTest

@testable import SwiftUIExample

class LandmarkRowTest: XCTestCase {
    func testFavoriteLandmarkRowDisplaysWithStar() throws {
        let expectedLandmark = Landmark.createForTests(id: Int.random(in: 1000..<10000),
                                               name: Faker().address.city(),
                                               park: Faker().address.city(),
                                               state: Faker().address.state(),
                                               description: Faker().lorem.paragraphs(),
                                               isFavorite: true,
                                               isFeatured: Bool.random(),
                                               category: Landmark.Category.allCases.randomElement()!,
                                               coordinates: Landmark.Coordinates(latitude: Faker().address.latitude(),
                                                                                 longitude: Faker().address.longitude()))
        let landmarkRow = try LandmarkRow(landmark: expectedLandmark).inspect()

        XCTAssertEqual(try landmarkRow.find(ViewType.Image.self).actualImage(), expectedLandmark.image.resizable())
        XCTAssertEqual(try landmarkRow.find(ViewType.Text.self).string(), expectedLandmark.name)
        XCTAssertEqual(try landmarkRow.find(ViewType.Image.self, skipFound: 1).actualImage(), Image(systemName: "star.fill"))
        XCTAssertEqual(try landmarkRow.find(ViewType.Image.self, skipFound: 1).foregroundColor(), .yellow)
    }

    func testNonFavoriteLandmarkRowDisplaysWithoutStar() throws {
        let expectedLandmark = Landmark.createForTests(id: Int.random(in: 1000..<10000),
                                               name: Faker().address.city(),
                                               park: Faker().address.city(),
                                               state: Faker().address.state(),
                                               description: Faker().lorem.paragraphs(),
                                               isFavorite: false,
                                               isFeatured: Bool.random(),
                                               category: Landmark.Category.allCases.randomElement()!,
                                               coordinates: Landmark.Coordinates(latitude: Faker().address.latitude(),
                                                                                 longitude: Faker().address.longitude()))

        let landmarkRow = try LandmarkRow(landmark: expectedLandmark).inspect()

        XCTAssertEqual(try landmarkRow.find(ViewType.Image.self).actualImage(), expectedLandmark.image.resizable())
        XCTAssertEqual(try landmarkRow.find(ViewType.Text.self).string(), expectedLandmark.name)
        XCTAssertThrowsError(try landmarkRow.find(ViewType.Image.self, skipFound: 1).actualImage())
    }
}
