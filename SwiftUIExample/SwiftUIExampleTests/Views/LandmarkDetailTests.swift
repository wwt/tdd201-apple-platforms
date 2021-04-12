//
//  LandmarkDetailTests.swift
//  SwiftUIExampleTests
//
//  Created by Richard Gist on 4/8/21.
//

import SwiftUI
import ViewInspector
import Combine
import Cuckoo
import XCTest

@testable import SwiftUIExample

class LandmarkDetailTests: XCTestCase {
    func testViewHasExpectedViews() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)
        let landmark = appModel.landmarks.randomElement()!

        let exp = ViewHosting.loadView(LandmarkDetail(landmark: landmark), environmentObject: appModel).inspection.inspect { view in
            let scrollView = XCTAssertNoThrowAndAssign(try view.find(ViewType.ScrollView.self))

            let mapView = XCTAssertNoThrowAndAssign(try scrollView?.find(MapView.self))
            XCTAssertEqual(try mapView?.actualView().coordinate.latitude, landmark.locationCoordinate.latitude)
            XCTAssertEqual(try mapView?.actualView().coordinate.longitude, landmark.locationCoordinate.longitude)

            let circleImage = XCTAssertNoThrowAndAssign(try scrollView?.find(CircleImage.self))
            XCTAssertEqual(try circleImage?.actualView().image, landmark.image)

            let landmarkName = XCTAssertNoThrowAndAssign(try scrollView?.find(ViewType.Text.self))
            XCTAssertEqual(try landmarkName?.string(), landmark.name)

            let favoriteButton = XCTAssertNoThrowAndAssign(try scrollView?.find(FavoriteButton.self))
            XCTAssertEqual(try favoriteButton?.actualView().isSet, landmark.isFavorite)

            let landmarkPark = XCTAssertNoThrowAndAssign(try scrollView?.find(ViewType.Text.self, skipFound: 1))
            XCTAssertEqual(try landmarkPark?.string(), landmark.park)
            let landmarkState = XCTAssertNoThrowAndAssign(try scrollView?.find(ViewType.Text.self, skipFound: 2))
            XCTAssertEqual(try landmarkState?.string(), landmark.state)
            let landmarkAbout = XCTAssertNoThrowAndAssign(try scrollView?.find(ViewType.Text.self, skipFound: 3))
            XCTAssertEqual(try landmarkAbout?.string(), "About \(landmark.name)")
            let landmarkDescription = XCTAssertNoThrowAndAssign(try scrollView?.find(ViewType.Text.self, skipFound: 4))
            XCTAssertEqual(try landmarkDescription?.string(), landmark.description)
        }
        wait(for: [exp], timeout: 1.5)
    }

    func testAppModelUpdatedWhenFavoriteButtonIsTapped() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)
        let landmarkIndex = appModel.landmarks.indices.randomElement()!
        let landmark = appModel.landmarks[landmarkIndex]
        MockHikesServiceProtocol().stub { stub in
            when(stub.setFavorite(to: any(Bool.self), on: any(Landmark.self))).thenReturn(Result.Publisher(.success(landmark)).eraseToAnyPublisher())
        }.registerIn(.default)

        let exp = ViewHosting.loadView(LandmarkDetail(landmark: landmark), environmentObject: appModel).inspection.inspect { view in
            let favoriteButton = XCTAssertNoThrowAndAssign(try view.find(FavoriteButton.self))

            XCTAssertNoThrow(try favoriteButton?.button().tap())

            XCTAssertNotEqual(appModel.landmarks[landmarkIndex].isFavorite, landmark.isFavorite)
        }
        wait(for: [exp], timeout: 1.5)
    }

    func testHikeServiceIsUpdatedWhenIsFavoriteChangesOnLandmark() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)
        let landmarkIndex = appModel.landmarks.indices.randomElement()!
        let landmark = appModel.landmarks[landmarkIndex]
        let hikeService = MockHikesServiceProtocol().stub { stub in
            when(stub.setFavorite(to: any(Bool.self), on: any(Landmark.self))).thenReturn(Result.Publisher(.success(landmark)).eraseToAnyPublisher())
        }.registerIn(.default)

        let exp = ViewHosting.loadView(LandmarkDetail(landmark: landmark), environmentObject: appModel).inspection.inspect { view in
            XCTAssertNoThrow(try view.find(FavoriteButton.self).button().tap())
        }
        wait(for: [exp], timeout: 1.5)

        let landmarkUpdated = ArgumentCaptor<Landmark>()
        let changedTo = ArgumentCaptor<Bool>()
        verify(hikeService, times(1)).setFavorite(to: changedTo.capture(), on: landmarkUpdated.capture())
        XCTAssertEqual(changedTo.value, appModel.landmarks[landmarkIndex].isFavorite)
        XCTAssertEqual(landmarkUpdated.value, appModel.landmarks[landmarkIndex])
    }
}