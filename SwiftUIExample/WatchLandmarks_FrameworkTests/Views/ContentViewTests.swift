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

@testable import WatchLandmarks_Framework

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

            XCTAssertNoThrow(try view.group().view(LandmarkList.self, 0))
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
            try view.group().callOnAppear()

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
            _ = try view.group().progressView(0)
        }
        wait(for: [exp], timeout: 3)
    }
}
