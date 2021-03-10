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
import Cuckoo
import Swinject

@testable import SwiftUIExample

class LandmarkDetailTests: XCTestCase {
    override func setUpWithError() throws {
        Container.default.removeAll()
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

        wait(for: [exp], timeout: 3.0)
    }

    func testLandmarkDetail_OnChangeBullshit() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)
        let expectedLandmark = appModel.landmarks[0]
        let expectation = self.expectation(description: "Stub called")

        let mockHikesService = MockHikesServiceProtocol().stub { stub in
            when(stub.setFavorite(to: any(), on: any())).then { _ in
                expectation.fulfill()
                return Result.Publisher(.success(expectedLandmark)).eraseToAnyPublisher()
            }
        }.registerIn(Container.default)

        let exp = ViewHosting.loadView(LandmarkDetail(landmark: expectedLandmark), data: appModel).inspection.inspect { (view) in
            try view.find(FavoriteButton.self).button().tap()
        }

        wait(for: [exp, expectation], timeout: 3)
        let captor = ArgumentCaptor<Landmark>()
        verify(mockHikesService, times(1)).setFavorite(to: !expectedLandmark.isFavorite, on: captor.capture())
        XCTAssertEqual(captor.value?.id, expectedLandmark.id)
    }
}
