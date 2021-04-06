//
//  LandmarkDetailTests.swift
//  WatchLandmarks_FrameworkTests
//
//  Created by thompsty on 4/6/21.
//

import Foundation
import XCTest
import ViewInspector

@testable import WatchLandmarks_Framework // except this is really the watch extension in disguise

class LandmarkDetailTests: XCTestCase {
    func testLandmarkDetailDisplaysTheThings() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let expectedLandmark = appModel.landmarks[0]

        let exp = ViewHosting.loadView(LandmarkDetail(landmark: expectedLandmark), data: appModel).inspection.inspect { (view) in
            let circleImage = try view.find(CircleImage.self)
            let name = try view.find(ViewType.Text.self, index: 0)
            let toggle = try view.find(ViewType.Toggle.self)
            let park = try view.find(ViewType.Text.self, index: 1)
            let state = try view.find(ViewType.Text.self, index: 2)
            let mapView = try view.find(MapView.self)

            XCTAssertEqual(try circleImage.actualView().image, expectedLandmark.image.resizable())
            XCTAssertEqual(try toggle.isOn(), expectedLandmark.isFavorite)
            XCTAssertEqual(try toggle.labelView().text().string(), "Favorite")
            XCTAssertEqual(try name.string(), expectedLandmark.name)
            XCTAssertEqual(try park.string(), expectedLandmark.park)
            XCTAssertEqual(try state.string(), expectedLandmark.state)
            XCTAssertEqual(try mapView.actualView().coordinate.latitude, expectedLandmark.locationCoordinate.latitude)
            XCTAssertEqual(try mapView.actualView().coordinate.longitude, expectedLandmark.locationCoordinate.longitude)
        }

        wait(for: [exp], timeout: 3.0)
    }
}
