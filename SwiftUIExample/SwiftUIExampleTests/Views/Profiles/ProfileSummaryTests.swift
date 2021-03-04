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
import SnapshotTesting

@testable import SwiftUIExample

class ProfileSummaryTests: XCTestCase {
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        let view = ProfileSummary(profile: Profile.default).environmentObject(ModelData())
        assertSnapshot(matching: view, as: .image(precision: 0.99, layout: .device(config: .iPhoneXsMax)))
    }

    func testProfileSummary() throws {
        let expectedProfile = Profile(username: Faker().internet.username(),
                                      prefersNotifications: true,
                                      seasonalPhoto: Profile.Season.allCases.randomElement() ?? .autumn,
                                      goalDate: Faker().date.forward(10))
        let modelData = ModelData()
        let exp = ViewHosting.loadView(ProfileSummary(profile: expectedProfile), data: modelData).inspection.inspect { view in
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 0).string(), expectedProfile.username)
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 0).attributes().font(), .title)

            XCTAssertEqual(try view.find(ViewType.Text.self, index: 1).string(), "Notifications: On")
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 2).string(), "Seasonal Photos: \(expectedProfile.seasonalPhoto.rawValue)")
            #warning("Inspection of formatted Date is not currently supported")
//            XCTAssertEqual(try view.find(ViewType.Text.self, index: 3).string(), "Goal Date: \(expectedProfile.goalDate)")
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 4).string(), "Completed Badges")
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 4).attributes().font(), .headline)
            XCTAssertEqual(try view.find(HikeBadge.self, index: 0).actualView().name, "First Hike")
            XCTAssertEqual(try view.find(HikeBadge.self, index: 1).actualView().name, "Earth Day")
            XCTAssertEqual(try view.find(HikeBadge.self, index: 2).actualView().name, "Tenth Hike")
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 5).string(), "Recent Hikes")
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 5).attributes().font(), .headline)
            XCTAssertEqual(try view.find(HikeView.self).actualView().hike, modelData.hikes.first)
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testNotificationsAreNotEnabled() throws {
        let expectedProfile = Profile(username: Faker().internet.username(),
                                      prefersNotifications: false,
                                      seasonalPhoto: Profile.Season.allCases.randomElement() ?? .autumn,
                                      goalDate: Faker().date.forward(10))
        let modelData = ModelData()
        let exp = ViewHosting.loadView(ProfileSummary(profile: expectedProfile), data: modelData).inspection.inspect { view in
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 1).string(), "Notifications: Off")
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testMakeAppleCodeExplodeBecauseItsBad() throws {
        let expectedProfile = Profile(username: Faker().internet.username(),
                                      prefersNotifications: true,
                                      seasonalPhoto: Profile.Season.allCases.randomElement() ?? .autumn,
                                      goalDate: Faker().date.forward(10))
        let modelData = ModelData()
        modelData.hikes = []
        let exp = ViewHosting.loadView(ProfileSummary(profile: expectedProfile), data: modelData).inspection.inspect { view in
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 5).attributes().font(), .headline)
            XCTAssertThrowsError(try view.find(HikeView.self))
        }
        wait(for: [exp], timeout: 0.1)
    }
}
