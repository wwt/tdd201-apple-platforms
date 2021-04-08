//
//  ContentViewTests.swift
//  SwiftUIExampleTests
//
//  Created by Richard Gist on 4/8/21.
//

import Foundation
import XCTest
import ViewInspector
import SwiftUI
import Cuckoo
import Combine
import Swinject

@testable import SwiftUIExample

class ContentViewTests: XCTestCase {
    func testViewHasExpectedViews() throws {
        MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get).thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
            when(stub.fetchHikes.get).thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
        }.registerIn(.default)

        let exp = ViewHosting.loadView(ContentView(), environmentObject: AppModel()).inspection.inspect { view in
            XCTAssertNoThrow(try view.find(ViewType.TabView.self))
            let tabView = try view.find(ViewType.TabView.self)

            XCTAssertNoThrow(try tabView.find(CategoryHome.self))
            let categoryHome = try tabView.find(CategoryHome.self)
            XCTAssertNoThrow(try categoryHome.tabItem().label())
            XCTAssertEqual(try categoryHome.tabItem().label().title().text().string(), "Featured")
            XCTAssertEqual(try categoryHome.tabItem().label().icon().image().actualImage(), Image(systemName: "star"))

            XCTAssertNoThrow(try tabView.find(LandmarkList.self))
            let landmarkList = try tabView.find(LandmarkList.self)
            XCTAssertNoThrow(try landmarkList.tabItem().label())
            XCTAssertEqual(try landmarkList.tabItem().label().title().text().string(), "List")
            XCTAssertEqual(try landmarkList.tabItem().label().icon().image().actualImage(), Image(systemName: "list.bullet"))
        }
        wait(for: [exp], timeout: 1.5)
    }

    func testFetchHikesWhenViewAppears() throws {
        let expectedHikes = [Hike(id: Int.random(in: 1000..<10000),
                                  name: UUID().uuidString,
                                  distance: Double.random(in: 100...200),
                                  difficulty: Int.random(in: 1...10),
                                  observations: [])]
        let hikesService = MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get).thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
            when(stub.fetchHikes.get).thenReturn(Result.Publisher(.success(expectedHikes)).eraseToAnyPublisher())
        }.registerIn(.default)
        let appModel = AppModel()

        let exp = ViewHosting.loadView(ContentView(), environmentObject: appModel).inspection.inspect { view in
            clearInvocations(hikesService)
            try view.tabView().callOnAppear()

            verify(hikesService, times(1)).fetchHikes.get()
            XCTAssertEqual(appModel.hikes, expectedHikes)
        }
        wait(for: [exp], timeout: 1.5)
    }

    func testProgressViewIsShownWhenFetchHikesIsInProgress() throws {
        MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get).thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
            when(stub.fetchHikes.get).thenReturn(Result.Publisher(.success([])).delay(for: 1.8, scheduler: DispatchQueue.main).eraseToAnyPublisher())
        }.registerIn(.default)

        let exp = ViewHosting.loadView(ContentView(), environmentObject: AppModel()).inspection.inspect { view in
            XCTAssertNoThrow(try view.find(ViewType.TabView.self))
            let tabView = try view.find(ViewType.TabView.self)

            XCTAssertNoThrow(try tabView.find(ViewType.ProgressView.self))
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
            when(stub.fetchHikes.get).thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
        }.registerIn(.default)
        let appModel = AppModel()

        let exp = ViewHosting.loadView(ContentView(), environmentObject: appModel).inspection.inspect { view in
            clearInvocations(hikesService)
            try view.tabView().callOnAppear()

            verify(hikesService, times(1)).fetchLandmarks.get()
            XCTAssertEqual(appModel.landmarks, expectedLandmarks)
        }
        wait(for: [exp], timeout: 1.5)
    }

    func testProgressViewIsShownWhenFetchLandmarksIsInProgress() throws {
        MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get).thenReturn(Result.Publisher(.success([])).delay(for: 1.8, scheduler: DispatchQueue.main).eraseToAnyPublisher())
            when(stub.fetchHikes.get).thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
        }.registerIn(.default)

        let exp = ViewHosting.loadView(ContentView(), environmentObject: AppModel()).inspection.inspect { view in
            XCTAssertNoThrow(try view.find(ViewType.TabView.self))
            let tabView = try view.find(ViewType.TabView.self)

            XCTAssertNoThrow(try tabView.find(ViewType.ProgressView.self))
        }
        wait(for: [exp], timeout: 1.5)
    }
}
