//
//  LandmarkDetailTests.swift
//  SwiftUIExampleTests
//
//  Created by david.roff on 5/20/21.
//

import Foundation
import ViewInspector
import XCTest
import SwiftUI
@testable import SwiftUIExample

class LandmarkDetailTests: XCTestCase {
    func testLandmarkDetail() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)
        let landmark = appModel.landmarks.randomElement()!
        let exp = ViewHosting.loadView(LandmarkDetail(landmark: landmark)).inspection.inspect { landmarkDetail in
            let scrollView = XCTAssertNoThrowAndAssign(try landmarkDetail.find(ViewType.ScrollView.self))
            let mapView = XCTAssertNoThrowAndAssign(try scrollView?.find(MapView.self))

            XCTAssertEqual(try mapView?.actualView().coordinate.latitude, landmark.locationCoordinate.latitude)
            XCTAssertEqual(try mapView?.actualView().coordinate.longitude, landmark.locationCoordinate.longitude)

            let circleImage = XCTAssertNoThrowAndAssign(try scrollView?.find(CircleImage.self))

            XCTAssertEqual(try circleImage?.actualView().image, landmark.image)

            let landmarkName = XCTAssertNoThrowAndAssign(try scrollView?.find(ViewType.Text.self))

            XCTAssertEqual(try landmarkName?.string(), landmark.name)

            let favoriteBtn = XCTAssertNoThrowAndAssign(try scrollView?.find(FavoriteButton.self))

            XCTAssertEqual(try favoriteBtn?.actualView().isSet, landmark.isFavorite)

            let landmarkPark = XCTAssertNoThrowAndAssign(try scrollView?.find(ViewType.Text.self, skipFound: 1))

            XCTAssertEqual(try landmarkPark?.string(), landmark.park)

            let landmarkState = XCTAssertNoThrowAndAssign(try scrollView?.find(ViewType.Text.self, skipFound: 2))

            XCTAssertEqual(try landmarkState?.string(), landmark.state)

            let landmarkAbout = XCTAssertNoThrowAndAssign(try scrollView?.find(ViewType.Text.self, skipFound: 3))

            XCTAssertEqual(try landmarkAbout?.string(), "About \(landmark.name)")

            let landmarkDescription = XCTAssertNoThrowAndAssign(try scrollView?.find(ViewType.Text.self, skipFound: 4))

            XCTAssertEqual(try landmarkDescription?.string(), landmark.description)
        }
        wait(for: [exp], timeout: 0.5)
    }
}

func XCTAssertNoThrowAndAssign<T>(_ expression: @autoclosure () throws -> T?,
                                  _ message: @autoclosure () -> String = "",
                                  file: StaticString = #file,
                                  line: UInt = #line) -> T? {
    XCTAssertNoThrow(try expression(), message(), file: file, line: line)

    if let expression = try? expression() {
        return expression
    }

    return nil
}
