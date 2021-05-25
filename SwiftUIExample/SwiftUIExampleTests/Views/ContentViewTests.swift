//
//  ContentViewTests.swift
//  SwiftUIExampleTests
//
//  Created by Zach Frew on 5/21/21.
//

import Cuckoo
import Fakery
import Swinject
import ViewInspector
import XCTest

@testable import SwiftUIExample

class ContentViewTests: XCTestCase {
    override class func setUp() {
        Container.default.removeAll()
    }

    func testContentView() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get)
                .thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
            when(stub.fetchHikes.get)
                .thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
        }.registerIn(.default)

        let exp = ViewHosting.loadView(ContentView(), data: appModel).inspection.inspect { contentView in
            let tabView = XCTAssertNoThrowAndAssign(try contentView.find(ViewType.TabView.self))

            XCTAssertNoThrow(try tabView?.view(CategoryHome.self, 0))
            XCTAssertNoThrow(try tabView?.view(LandmarkList.self, 1))
        }

        wait(for: [exp], timeout: 0.5)
    }

    func testContentViewFetchesHikesOnAppear() throws {
        let expectedHikes = [
            Hike(id: Int.random(in: 1000..<10000),
                 name: Faker().name.name(),
                 distance: Double.random(in: 100...200),
                 difficulty: Int.random(in: 1...10),
                 observations: [])
        ]

        let mock = MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get)
                .thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
            when(stub.fetchHikes.get)
                .thenReturn(Result.Publisher(.success(expectedHikes)).eraseToAnyPublisher())
        }.registerIn(.default)

        let appModel = AppModel()

        let exp = ViewHosting.loadView(ContentView(), data: appModel).inspection.inspect { contentView in
            clearInvocations(mock)
            try contentView.tabView().callOnAppear()

            verify(mock, times(1)).fetchHikes.get()
            XCTAssertEqual(appModel.hikes, expectedHikes)
        }

        wait(for: [exp], timeout: 0.5)
    }

    func testContentViewFetchesLandmarksOnAppear() throws {
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

        let exp = ViewHosting.loadView(ContentView(), data: appModel).inspection.inspect { contentView in
            clearInvocations(mock)
            try contentView.tabView().callOnAppear()

            verify(mock, times(1)).fetchLandmarks.get()
            XCTAssertEqual(appModel.landmarks, expectedLandmarks)
        }

        wait(for: [exp], timeout: 0.5)
    }

    func testWhenFetchingLandmarksFails_AlertIsPresented() throws {
        enum Err: Error {
            case e1
        }

        let mock = MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get)
                .thenReturn(Result.Publisher(.failure(API.HikesService.Error.apiBorked(Err.e1))).eraseToAnyPublisher())
            when(stub.fetchHikes.get)
                .thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
        }.registerIn(.default)

        let appModel = AppModel()

        let exp = ViewHosting.loadView(ContentView(), data: appModel).inspection.inspect { contentView in
            clearInvocations(mock)
            try contentView.tabView().callOnAppear()

            verify(mock, times(1)).fetchLandmarks.get()
            let alert = XCTAssertNoThrowAndAssign(try contentView.find(ViewType.Alert.self))

            XCTAssertEqual(try alert?.title().string(), Err.e1.localizedDescription)
        }

        wait(for: [exp], timeout: 1)
    }

    func testWhenFetchingHikesFails_AlertIsPresented() throws {
        enum Err: Error {
            case e1
        }

        let mock = MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get)
                .thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
            when(stub.fetchHikes.get)
                .thenReturn(Result.Publisher(.failure(API.HikesService.Error.apiBorked(Err.e1))).eraseToAnyPublisher())
        }.registerIn(.default)

        let appModel = AppModel()

        let exp = ViewHosting.loadView(ContentView(), data: appModel).inspection.inspect { contentView in
            clearInvocations(mock)
            try contentView.tabView().callOnAppear()

            verify(mock, times(1)).fetchHikes.get()
            let alert = XCTAssertNoThrowAndAssign(try contentView.find(ViewType.Alert.self))

            XCTAssertEqual(try alert?.title().string(), Err.e1.localizedDescription)
        }

        wait(for: [exp], timeout: 1)
    }

    func testWhenFetchingBothHikesAndLandmarksFails_AlertIsPresented() throws {
        enum Err: Error {
            case e1
            case e2
        }

        let mock = MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get)
                .thenReturn(Result.Publisher(.failure(API.HikesService.Error.apiBorked(Err.e1))).eraseToAnyPublisher())
            when(stub.fetchHikes.get)
                .thenReturn(Result.Publisher(.failure(API.HikesService.Error.apiBorked(Err.e2))).eraseToAnyPublisher())
        }.registerIn(.default)

        let appModel = AppModel()

        let exp = ViewHosting.loadView(ContentView(), data: appModel).inspection.inspect { contentView in
            clearInvocations(mock)
            try contentView.tabView().callOnAppear()

            verify(mock, times(1)).fetchHikes.get()
            verify(mock, times(1)).fetchLandmarks.get()
            let alert = XCTAssertNoThrowAndAssign(try contentView.find(ViewType.Alert.self))

            XCTAssertEqual(try alert?.title().string(), [Err.e2.localizedDescription, Err.e1.localizedDescription].joined(separator: "\n"))
        }

        wait(for: [exp], timeout: 1)
    }

    func testProgressViewExistsWhileMakingNetworkCall() throws {
        MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get)
                .thenReturn(Result.Publisher(.success([])).delay(for: 10, scheduler: DispatchQueue.main).eraseToAnyPublisher())
            when(stub.fetchHikes.get)
                .thenReturn(Result.Publisher(.success([])).delay(for: 10, scheduler: DispatchQueue.main).eraseToAnyPublisher())
        }.registerIn(.default)

        let appModel = AppModel()

        let exp = ViewHosting.loadView(ContentView(), data: appModel).inspection.inspect { contentView in
            XCTAssertNoThrow(try contentView.find(ViewType.ProgressView.self))
        }

        wait(for: [exp], timeout: 0.5)
    }
}
