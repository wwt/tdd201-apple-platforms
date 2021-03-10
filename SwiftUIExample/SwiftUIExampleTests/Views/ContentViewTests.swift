//
//  ContentViewTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/25/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector
import Swinject
import Cuckoo
import Fakery

@testable import SwiftUIExample

class ContentViewTests: XCTestCase {
    override func setUpWithError() throws {
        Container.default.removeAll()
    }

    func testContentView() throws {
        MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get).thenReturn(
                Result.Publisher(.success([]))
                    .eraseToAnyPublisher()
            )
            when(stub.fetchHikes.get).thenReturn(
                Result.Publisher(.success([]))
                    .eraseToAnyPublisher()
            )
        }.registerIn(Container.default)
        let exp = ViewHosting.loadView(ContentView(), data: AppModel()).inspection.inspect { (view) in
            let tabView = try view.find(ViewType.TabView.self)

            XCTAssertNoThrow(try tabView.view(CategoryHome.self, 0))
            XCTAssertThrowsError(try tabView.view(LandmarkList.self, 0))
        }
        wait(for: [exp], timeout: 3)
    }

    func testContentView_FetchesHikesOnAppear() throws {
        let expectedHikes = [Hike(id: Int.random(in: 1000..<10000),
                                  name: UUID().uuidString,
                                  distance: Double.random(in: 100...200),
                                  difficulty: Int.random(in: 1...10),
                                  observations: [])]
        let mockHikesService = MockHikesServiceProtocol().stub { stub in
            when(stub.fetchHikes.get).thenReturn(
                Result.Publisher(.success(expectedHikes)).eraseToAnyPublisher()
            )
            when(stub.fetchLandmarks.get).thenReturn(
                Result.Publisher(.success([])).eraseToAnyPublisher()
            )
        }.registerIn(Container.default)

        let appModel = AppModel()
        let exp = ViewHosting.loadView(ContentView(), data: appModel).inspection.inspect { view in
            // on appear called by ViewHosting, clear invocations for mock before continuing
            clearInvocations(mockHikesService)
            try view.tabView().callOnAppear()

            verify(mockHikesService, times(1)).fetchHikes.get()
            XCTAssertEqual(appModel.hikes, expectedHikes)
        }
        wait(for: [exp], timeout: 3)
    }

    func testContentView_FetchesLandmarksOnAppear() throws {
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
        let exp = ViewHosting.loadView(ContentView(), data: appModel).inspection.inspect { view in
            // on appear called by ViewHosting, clear invocations for mock before continuing
            clearInvocations(mockHikesService)
            try view.tabView().callOnAppear()

            verify(mockHikesService, times(1)).fetchLandmarks.get()
            XCTAssertEqual(appModel.landmarks, expectedLandmarks)
        }
        wait(for: [exp], timeout: 3)
    }

    func testContentView_ShowsProgressSpinnerWhileFetchingHikesAndLandmarks() throws {
        MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get).thenReturn(
                Result.Publisher(.success([]))
                    .delay(for: 10, scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            )
            when(stub.fetchHikes.get).thenReturn(
                Result.Publisher(.success([]))
                    .delay(for: 10, scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            )
        }.registerIn(Container.default)

        let appModel = AppModel()
        let exp = ViewHosting.loadView(ContentView(), data: appModel).inspection.inspect { view in
            _ = try view.tabView().progressView(0)
        }
        wait(for: [exp], timeout: 3)
    }
}
