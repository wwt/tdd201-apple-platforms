//
//  LandmarkListTests.swift
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

class LandmarkListTests: XCTestCase {
    func testViewHasExpectedViews() throws {
        MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get).thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
        }.registerIn(.default)
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let exp = ViewHosting.loadView(LandmarkList(), environmentObject: appModel).inspection.inspect { view in
            let navigationView = XCTAssertNoThrowAndAssign(try view.find(ViewType.NavigationView.self))
            let list = XCTAssertNoThrowAndAssign(try navigationView?.find(ViewType.List.self))
            let toggle = XCTAssertNoThrowAndAssign(try list?.find(ViewType.Toggle.self))

            XCTAssertEqual(try toggle?.isOn(), false)
            XCTAssertEqual(try toggle?.find(ViewType.Text.self).string(), "Favorites only")
            XCTAssertEqual(try list?.find(ViewType.ForEach.self).count, appModel.landmarks.count)

            try list?.find(ViewType.ForEach.self).enumerated().forEach { each in
                let navigationLink = XCTAssertNoThrowAndAssign(try each.element.find(ViewType.NavigationLink.self))
                let landmarkDetail = XCTAssertNoThrowAndAssign(try navigationLink?.view(LandmarkDetail.self))
                let landmarkRow = XCTAssertNoThrowAndAssign(try navigationLink?.labelView().find(LandmarkRow.self))

                XCTAssertEqual(try landmarkDetail?.actualView().landmark, appModel.landmarks[each.offset])
                XCTAssertEqual(try landmarkRow?.actualView().landmark, appModel.landmarks[each.offset])
            }
        }
        wait(for: [exp], timeout: 1.5)
    }

    func testFavoritesShownWhenToggleTapped() throws {
        MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get).thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
        }.registerIn(.default)
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let exp = ViewHosting.loadView(LandmarkList(), environmentObject: appModel).inspection.inspect { view in
            let navigationView = XCTAssertNoThrowAndAssign(try view.find(ViewType.NavigationView.self))
            let list = XCTAssertNoThrowAndAssign(try navigationView?.find(ViewType.List.self))
            let toggle = XCTAssertNoThrowAndAssign(try list?.find(ViewType.Toggle.self))

            XCTAssertEqual(try toggle?.isOn(), false)
            XCTAssertEqual(try list?.find(ViewType.ForEach.self).count, appModel.landmarks.count)
            try toggle?.tap()

            XCTAssertEqual(try toggle?.isOn(), true)
            XCTAssertEqual(try view.navigationView().find(ViewType.List.self).find(ViewType.ForEach.self).count, appModel.landmarks.filter({ $0.isFavorite }).count)
        }
        wait(for: [exp], timeout: 1.5)
    }

    func testFetchLandmarksWhenViewAppears() throws {
        let expectedLandmarks = [Landmark.createForTests(id: Int.random(in: 1000...10000),
                                                         name: UUID().uuidString,
                                                         park: UUID().uuidString,
                                                         state: UUID().uuidString,
                                                         description: UUID().uuidString,
                                                         isFavorite: Bool.random(),
                                                         isFeatured: Bool.random(),
                                                         category: .mountains,
                                                         coordinates: .init(latitude: 1, longitude: 2))]
        let hikesService = MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get).thenReturn(Result.Publisher(.success(expectedLandmarks)).eraseToAnyPublisher())
        }.registerIn(.default)
        let appModel = AppModel()

        let exp = ViewHosting.loadView(LandmarkList(), environmentObject: appModel).inspection.inspect { view in
            clearInvocations(hikesService)
            try view.navigationView().callOnAppear()

            verify(hikesService, times(1)).fetchLandmarks.get()
            XCTAssertEqual(appModel.landmarks, expectedLandmarks)
        }
        wait(for: [exp], timeout: 1.5)
    }
}
