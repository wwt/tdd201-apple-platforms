//
//  ProfileSummaryTests.swift
//  SwiftUIExampleTests
//
//  Created by david.roff on 5/25/21.
//

import Fakery
import Foundation
import SwiftUI
import ViewInspector
import XCTest

@testable import SwiftUIExample

class ProfileSummaryTests: XCTestCase {
    func testProfileSummary() throws {
        let expectedHikes = [Hike(id: 1,
                                  name: Faker().name.name(),
                                  distance: Faker().number.randomDouble(),
                                  difficulty: Faker().number.randomInt(),
                                  observations: [Hike.Observation(distanceFromStart: 10.0, elevation: 10..<20, pace: 10..<20, heartRate: 65..<150)])]
        let expectedProfile = Profile(username: Faker().internet.username(),
                                      prefersNotifications: true,
                                      seasonalPhoto: Profile.Season.allCases.randomElement()!,
                                      goalDate: Faker().date.forward(5))
        let exp = ViewHosting.loadView(ProfileSummary(hikes: .constant(expectedHikes),
                                                      profile: expectedProfile),
                                       data: AppModel(),
                                       keyPath: \.editMode,
                                       keyValue: .constant(.inactive)).inspection.inspect { profileSummary in
                                        XCTAssertEqual(try profileSummary.find(ViewType.Text.self).string(), expectedProfile.username)
                                        XCTAssertEqual(try profileSummary.find(ViewType.Text.self, skipFound: 1).string(),
                                                       "Notifications: On")
                                        XCTAssertEqual(try profileSummary.find(ViewType.Text.self, skipFound: 2).string(),
                                                       "Seasonal Photos: \(expectedProfile.seasonalPhoto.rawValue)")
                                        XCTAssertEqual(try profileSummary.find(ViewType.Text.self, skipFound: 4).string(),
                                                       "Completed Badges")
                                        XCTAssertEqual(profileSummary.findAll(Badge.self).count, 3)
                                        XCTAssertEqual(try profileSummary.find(ViewType.Text.self,
                                                                               traversal: .depthFirst,
                                                                               skipFound: 5).string(),
                                                       "First Hike")
                                        XCTAssertEqual(try profileSummary.find(ViewType.Text.self,
                                                                               traversal: .depthFirst,
                                                                               skipFound: 6).string(),
                                                       "Earth Day")
                                        XCTAssertEqual(try profileSummary.find(ViewType.Text.self,
                                                                               traversal: .depthFirst,
                                                                               skipFound: 7).string(),
                                                       "Tenth Hike")
                                        XCTAssertEqual(try profileSummary.find(ViewType.Text.self,
                                                                               skipFound: 5).string(),
                                                       "Recent Hikes")
                                        XCTAssertEqual(try profileSummary.find(HikeView.self).actualView().hike, expectedHikes.first)
        }
        wait(for: [exp], timeout: 0.5)
    }
}
