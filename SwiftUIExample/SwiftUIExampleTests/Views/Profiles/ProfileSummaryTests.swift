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

@testable import SwiftUIExample

class ProfileSummaryTests: XCTestCase {
    func testProfileSummary() throws {
        let expectedProfile = Profile(username: Faker().internet.username(),
                                      prefersNotifications: true,
                                      seasonalPhoto: Profile.Season.allCases.randomElement() ?? .autumn,
                                      goalDate: Faker().date.forward(10))

        let exp = ViewHosting.loadView(ProfileSummary(profile: expectedProfile), data: ModelData()).inspection.inspect { view in
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 0).string(), expectedProfile.username)
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 0).attributes().font(), .title)

            XCTAssertEqual(try view.find(ViewType.Text.self, index: 1).string(), "Notifications: On")
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 2).string(), "Seasonal Photos: \(expectedProfile.seasonalPhoto.rawValue)")
            #warning("Inspection of formatted Date is not currently supported")
//            XCTAssertEqual(try view.find(ViewType.Text.self, index: 3).string(), "Goal Date: \(expectedProfile.goalDate)")
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 4).string(), "Completed Badges")
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 4).attributes().font(), .headline)
            XCTAssertEqual(try view.findAll(HikeBadge.self).first?.actualView().name, "First Hike")
        }
        wait(for: [exp], timeout: 0.1)
    }

}
