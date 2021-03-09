//
//  LandmarkListTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/22/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector
import SnapshotTesting
import Swinject
import Cuckoo
import Fakery

@testable import SwiftUIExample

class LandmarkListTests: XCTestCase {
    override func setUpWithError() throws {
        Container.default.removeAll()
    }

    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)

        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let view = LandmarkList().environmentObject(appModel)
        assertSnapshot(matching: view, as: .image(precision: 0.99))
    }

    func testLandmarkListDisplaysTheThings() throws {
        let file = Bundle.main.url(forResource: "landmarkData", withExtension: "json")!
        let data = try Data(contentsOf: file)
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: data)

        let exp = ViewHosting.loadView(LandmarkList(), data: appModel).inspection.inspect { (view) in
            let list = try view.navigationView().find(ViewType.List.self)
            let toggle = try list.find(ViewType.Toggle.self)

            XCTAssertEqual(try list.find(ViewType.ForEach.self).count, appModel.landmarks.count)
            try list.find(ViewType.ForEach.self).enumerated().forEach {
                let navLink = try $0.element.find(ViewType.NavigationLink.self)
                let landmarkDetail = try navLink.view(LandmarkDetail.self)
                let landmarkRow = try navLink.labelView().find(LandmarkRow.self)
                XCTAssertEqual(try landmarkDetail.actualView().landmark, appModel.landmarks[$0.offset])
                XCTAssertEqual(try landmarkRow.actualView().landmark, appModel.landmarks[$0.offset])
            }

            XCTAssertEqual(try toggle.find(ViewType.Text.self).string(), "Favorites only")
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testLandmarkListTogglesFavorites() throws {
        let file = Bundle.main.url(forResource: "landmarkData", withExtension: "json")!
        let data = try Data(contentsOf: file)
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: data)

        let exp = ViewHosting.loadView(LandmarkList(), data: appModel).inspection.inspect { (view) in
            let list = try view.navigationView().find(ViewType.List.self)
            let toggle = try list.find(ViewType.Toggle.self)

            XCTAssertFalse(try toggle.isOn())
            XCTAssertEqual(try list.find(ViewType.ForEach.self).count, appModel.landmarks.count)
            try toggle.tap()
            XCTAssert(try toggle.isOn())
            XCTAssertEqual(try view.navigationView().find(ViewType.List.self).find(ViewType.ForEach.self).count, 3)
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testLandmarkListView_FetchesLandmarksOnAppear() throws {
        let expectedLandmarks = [Landmark.createForTests(id: Int.random(in: 1000..<10000),
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
        let mockHikesService = MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get).thenReturn(
                Result.Publisher(.success(expectedLandmarks)).eraseToAnyPublisher()
            )
            when(stub.fetchHikes.get).thenReturn(
                Result.Publisher(.success([])).eraseToAnyPublisher()
            )
        }.registerIn(Container.default)

        let appModel = AppModel()
        let exp = ViewHosting.loadView(LandmarkList(), data: appModel).inspection.inspect { view in
            // on appear called by ViewHosting, clear invocations for mock before continuing
            clearInvocations(mockHikesService)
            try view.navigationView().callOnAppear()

            verify(mockHikesService, times(1)).fetchLandmarks.get()
            XCTAssertEqual(appModel.landmarks, expectedLandmarks)
        }
        wait(for: [exp], timeout: 0.1)
    }
}
