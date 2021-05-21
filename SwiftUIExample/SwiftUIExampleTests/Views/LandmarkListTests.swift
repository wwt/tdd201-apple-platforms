//
//  LandmarkListTests.swift
//  SwiftUIExampleTests
//
//  Created by Zach Frew on 5/21/21.
//

import Cuckoo
import Fakery
import ViewInspector
import Swinject
import XCTest

@testable import SwiftUIExample

class LandmarkListTests: XCTestCase {
    override func setUpWithError() throws {
        Container.default.removeAll()
    }

    func testLandmarkList() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let exp = ViewHosting.loadView(LandmarkList(), data: appModel).inspection.inspect { landmarkList in
            let list = XCTAssertNoThrowAndAssign(try landmarkList.find(ViewType.List.self))
            let toggle = XCTAssertNoThrowAndAssign(try list?.find(ViewType.Toggle.self))
            let forEach = XCTAssertNoThrowAndAssign(try list?.find(ViewType.ForEach.self))

            XCTAssertEqual(forEach?.count, appModel.landmarks.count)

            try forEach?.enumerated().forEach { offset, element in
                let navLink = XCTAssertNoThrowAndAssign(try element.find(ViewType.NavigationLink.self))
                let landmarkDetail = XCTAssertNoThrowAndAssign(try navLink?.view(LandmarkDetail.self))
                let landmarkRow = XCTAssertNoThrowAndAssign(try navLink?.labelView().find(LandmarkRow.self))

                XCTAssertEqual(try landmarkDetail?.actualView().landmark, appModel.landmarks[offset])
                XCTAssertEqual(try landmarkRow?.actualView().landmark, appModel.landmarks[offset])
            }

            XCTAssertEqual(try toggle?.find(ViewType.Text.self).string(), "Favorites only")
        }

        wait(for: [exp], timeout: 0.5)
    }

    func testLandmarkListCanToggleFavorites() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let exp = ViewHosting.loadView(LandmarkList(), data: appModel).inspection.inspect { landmarkList in
            let list = XCTAssertNoThrowAndAssign(try landmarkList.find(ViewType.List.self))
            let toggle = XCTAssertNoThrowAndAssign(try list?.find(ViewType.Toggle.self))

            XCTAssertEqual(try toggle?.isOn(), false)
            XCTAssertEqual(try list?.find(ViewType.ForEach.self).count, appModel.landmarks.count)

            try toggle?.tap()

            XCTAssertEqual(try toggle?.isOn(), true)
            XCTAssertEqual(try landmarkList.find(ViewType.List.self).find(ViewType.ForEach.self).count, appModel.landmarks.filter { $0.isFavorite }.count)
        }

        wait(for: [exp], timeout: 0.5)
    }

    func testLandmarkListFetchesLandmarksOnAppear() throws {
        let expectedLandmarks = [
            Landmark.createForTests(id: Int.random(in: 1000..<10000),
                                    name: Faker().address.city(),
                                    park: Faker().address.city(),
                                    state: Faker().address.state(),
                                    description: Faker().lorem.paragraphs(),
                                    isFavorite: Bool.random(),
                                    isFeatured: Bool.random(),
                                    category: Landmark.Category.allCases.randomElement()!,
                                    coordinates: Landmark.Coordinates(latitude: Faker().address.latitude(),
                                                                      longitude: Faker().address.longitude()))
        ]

        let mock = MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get)
                .thenReturn(Result.Publisher(.success(expectedLandmarks)).eraseToAnyPublisher())
            when(stub.fetchHikes.get)
                .thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
        }.registerIn(.default)

        let appModel = AppModel()

        let exp = ViewHosting.loadView(LandmarkList(), data: appModel).inspection.inspect { landmarkList in
            clearInvocations(mock)
            try landmarkList.navigationView().callOnAppear()

            verify(mock, times(1)).fetchLandmarks.get()
            XCTAssertEqual(appModel.landmarks, expectedLandmarks)
        }

        wait(for: [exp], timeout: 0.5)
    }
}
