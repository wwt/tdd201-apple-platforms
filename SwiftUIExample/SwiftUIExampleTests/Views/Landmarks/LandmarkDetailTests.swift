//
//  LandmarkDetailTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/22/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector
import SnapshotTesting

@testable import SwiftUIExample

class LandmarkDetailTests: XCTestCase {
    func testUIMatchesSnapshot() throws {
        // using dump ALMOST worked but was peering into memory addresses,
        // we could use a custom snapshot and make this work,
        // but it is out of the bounds of this lesson
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        let appModel = AppModel()
        appModel.profile.goalDate = Date(timeIntervalSince1970: 1000)
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let view = LandmarkDetail(landmark: appModel.landmarks[1]).environmentObject(appModel)
        assertSnapshot(matching: view, as: .description)
    }

    func testLandmarkDetailDisplaysTheThings() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let expectedLandmark = appModel.landmarks[0]

        let exp = ViewHosting.loadView(LandmarkDetail(landmark: expectedLandmark), data: appModel).inspection.inspect { (view) in
            let mapView = try view.find(MapView.self)
            let circleImage = try view.find(CircleImage.self)
            let vStack = try view.find(ViewType.VStack.self)
            let hStacks = view.findAll(ViewType.HStack.self)
            let nameText = try hStacks.first?.find(ViewType.Text.self)
            let favBtn = try hStacks.first?.find(FavoriteButton.self)
            let parkText = try hStacks.last?.text(0)
            let stateText = try hStacks.last?.text(2)
            let aboutText = try vStack.text(3)
            let descriptionText = try vStack.text(4)

            XCTAssertEqual(try mapView.actualView().coordinate.latitude, expectedLandmark.locationCoordinate.latitude)
            XCTAssertEqual(try mapView.actualView().coordinate.longitude, expectedLandmark.locationCoordinate.longitude)
            XCTAssertEqual(try circleImage.actualView().image, expectedLandmark.image)
            XCTAssertEqual(try nameText?.string(), expectedLandmark.name)
            XCTAssertEqual(try nameText?.attributes().font(), .title)
            XCTAssertEqual(try favBtn?.actualView().isSet, true)
            XCTAssertEqual(try parkText?.string(), expectedLandmark.park)
            XCTAssertEqual(try stateText?.string(), expectedLandmark.state)
            XCTAssertEqual(try aboutText.string(), "About \(expectedLandmark.name)")
            XCTAssertEqual(try descriptionText.string(), expectedLandmark.description)
            XCTAssertEqual(try hStacks.last?.font(), .subheadline)
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testLandmarkDetail_OnChangeBullshit() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let expectedLandmark = appModel.landmarks[0]

        let exp = ViewHosting.loadView(LandmarkDetail(landmark: expectedLandmark), data: appModel).inspection.inspect { (view) in
            try view.find(FavoriteButton.self).button().tap()
            XCTFail("There is not anything to assert because we got ahead of ourselves")
        }

        wait(for: [exp], timeout: 0.1)
    }
}
