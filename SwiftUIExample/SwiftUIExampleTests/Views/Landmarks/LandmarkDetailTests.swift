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
        let file = Bundle.main.url(forResource: "landmarkData", withExtension: "json")!
        let data = try Data(contentsOf: file)
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: data)

        let exp = ViewHosting.loadView(LandmarkDetail(landmark: expectedLandmark), data: appModel).inspection.inspect { (view) in
            let scrollView = try view.scrollView(0)
            let mapView = try scrollView.find(MapView.self)
            let circleImage = try scrollView.find(CircleImage.self)
            let vStack = try scrollView.find(ViewType.VStack.self)
            let hStacks = scrollView.findAll(ViewType.HStack.self)
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
}
