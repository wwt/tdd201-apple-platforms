//
//  ProfileSummaryTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/25/21.
//

import Foundation
import XCTest
import SwiftUI
import Fakery
import ViewInspector
import Swinject
import Cuckoo

@testable import SwiftUIExample

class ProfileSummaryTests: XCTestCase {
    func testProfileSummary() throws {
        let expectedProfile = Profile(username: Faker().internet.username(),
                                      prefersNotifications: true,
                                      seasonalPhoto: Profile.Season.allCases.randomElement() ?? .autumn,
                                      goalDate: Faker().date.forward(10))
        let appModel = AppModel()
        appModel.hikes = try JSONDecoder().decode([Hike].self, from: hikesJson)

        let exp = ViewHosting.loadView(ProfileSummary(hikes: .constant(appModel.hikes), profile: expectedProfile), data: appModel).inspection.inspect { view in
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 0).string(), expectedProfile.username)
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 0).attributes().font(), .title)

            XCTAssertEqual(try view.find(ViewType.Text.self, index: 1).string(), "Notifications: On")
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 2).string(), "Seasonal Photos: \(expectedProfile.seasonalPhoto.rawValue)")
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 4).string(), "Completed Badges")
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 4).attributes().font(), .headline)
            XCTAssertEqual(try view.find(HikeBadge.self, index: 0).actualView().name, "First Hike")
            XCTAssertEqual(try view.find(HikeBadge.self, index: 1).actualView().name, "Earth Day")
            XCTAssertEqual(try view.find(HikeBadge.self, index: 2).actualView().name, "Tenth Hike")
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 5).string(), "Recent Hikes")
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 5).attributes().font(), .headline)
            XCTAssertEqual(try view.find(HikeView.self).actualView().hike, appModel.hikes.first)
        }
        wait(for: [exp], timeout: 3.0)
    }

    func testNotificationsAreNotEnabled() throws {
        let expectedProfile = Profile(username: Faker().internet.username(),
                                      prefersNotifications: false,
                                      seasonalPhoto: Profile.Season.allCases.randomElement() ?? .autumn,
                                      goalDate: Faker().date.forward(10))
        let appModel = AppModel()
        let exp = ViewHosting.loadView(ProfileSummary(hikes: .constant(appModel.hikes), profile: expectedProfile), data: appModel).inspection.inspect { view in
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 1).string(), "Notifications: Off")
        }
        wait(for: [exp], timeout: 3.0)
    }

    func testMakeAppleCodeExplodeBecauseItsBad() throws {
        let expectedProfile = Profile(username: Faker().internet.username(),
                                      prefersNotifications: true,
                                      seasonalPhoto: Profile.Season.allCases.randomElement() ?? .autumn,
                                      goalDate: Faker().date.forward(10))
        let appModel = AppModel()
        appModel.hikes = []
        let exp = ViewHosting.loadView(ProfileSummary(hikes: .constant(appModel.hikes), profile: expectedProfile), data: appModel).inspection.inspect { view in
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 5).attributes().font(), .headline)
            XCTAssertThrowsError(try view.find(HikeView.self))
        }
        wait(for: [exp], timeout: 3)
    }

    func testProfileHost_FetchesHikesOnAppear() throws {
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
        let exp = ViewHosting.loadView(ProfileHost(), data: appModel).inspection.inspect { view in
            // on appear called by ViewHosting, clear invocations for mock before continuing
            clearInvocations(mockHikesService)
            try view.vStack().callOnAppear()

            verify(mockHikesService, times(1)).fetchHikes.get()
            XCTAssertEqual(appModel.hikes, expectedHikes)
        }
        wait(for: [exp], timeout: 3)
    }
}
