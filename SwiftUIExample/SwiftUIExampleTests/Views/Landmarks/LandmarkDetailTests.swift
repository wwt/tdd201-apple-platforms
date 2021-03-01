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

    func testUILooksAsExpected() throws {
        let modelData = ModelData()
        let view = LandmarkDetail(landmark: modelData.landmarks[1]).environmentObject(modelData)
        throw XCTSkip()
        assertSnapshot(matching: view, as: .image(precision: 0.99), record: true)
        XCTFail("Snapshot not working as expected")

    }

    func testLandmarkDetailDisplaysTheThings() throws {
        var expectedLandmark = try JSONDecoder().decode([Landmark].self, from: Self.landmark).first!
        expectedLandmark.isFavorite = false // explicitly set as false - it is true in model data
        let file = Bundle.main.url(forResource: "landmarkData", withExtension: "json")!
        let data = try Data(contentsOf: file)
        let modelData = ModelData()
        modelData.landmarks = try JSONDecoder().decode([Landmark].self, from: data)

        let exp = ViewHosting.loadView(LandmarkDetail(landmark: expectedLandmark), data: modelData).inspection.inspect { (view) in
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

#warning("extract this to be shared")
extension LandmarkDetailTests {
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
