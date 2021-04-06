//
//  NotificationViewTests.swift
//  WatchLandmarks_FrameworkTests
//
//  Created by Richard Gist on 4/6/21.
//

import Foundation
import ViewInspector
import XCTest

@testable import WatchLandmarks_Framework

class NotificationViewTests: XCTestCase {
    func testNotificationViewWithNotificationData() throws {
        let expectedTitle = UUID().uuidString
        let expectedMessage = UUID().uuidString
        let expectedLandmark = Landmark.createForTests(id: 123,
                                                       name: "Unexpected",
                                                       park: "parky",
                                                       state: "statey",
                                                       description: "Tyler doesn't like this",
                                                       isFavorite: true,
                                                       isFeatured: true,
                                                       category: .mountains,
                                                       coordinates: .init(latitude: 0, longitude: -1),
                                                       imageName: "turtlerock")
        let notificationView = try NotificationView(title: expectedTitle, message: expectedMessage, landmarkId: expectedLandmark.id, landmarkImage: expectedLandmark.image).inspect()

        let title = try notificationView.find(ViewType.Text.self, index: 0)
        let message = try notificationView.find(ViewType.Text.self, index: 1)
        let circleImage = try notificationView.find(CircleImage.self)

        XCTAssertEqual(try title.string(), expectedTitle)
        XCTAssertEqual(try message.string(), expectedMessage)
        XCTAssertEqual(try circleImage.actualView().image, expectedLandmark.image.resizable())
    }

    func testNotificationViewWithoutData() throws {
        let notificationView = try NotificationView(title: nil, message: nil, landmarkId: nil, landmarkImage: nil).inspect()

        let title = try notificationView.find(ViewType.Text.self, index: 0)
        let message = try notificationView.find(ViewType.Text.self, index: 1)

        XCTAssertEqual(try title.string(), "Unknown Landmark")
        XCTAssertEqual(try message.string(), "You are within 5 miles of one of your favorite landmarks.")
        XCTAssertThrowsError(try notificationView.find(CircleImage.self))
    }
}
