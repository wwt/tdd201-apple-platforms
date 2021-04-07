//
//  NotificationControllerTests.swift
//  WatchLandmarks_FrameworkTests
//
//  Created by Richard Gist on 4/6/21.
//

import Foundation
import ViewInspector
import XCTest
import SwiftUI
import UserNotifications

@testable import WatchLandmarks_Framework

class NotificationControllerTests: XCTestCase {
    func testDidReceiveNotification() throws {
        let notificationController = TestableNotificationController()

        notificationController.didReceive(FakeUNNotification.new)

        let body = notificationController.body

        XCTAssertEqual(body.title, nil)
        XCTAssertEqual(body.message, nil)
    }

    func testDidReceiveNotificationWithData() throws {
        let expectedTitle = "Landmark title"
        let expectedMessage = "Message stuff"
        let expectedLandmarkId = 1002
        let expectedLandmarkImage = Image("silversalmoncreek")
        let notificationController = TestableNotificationController()

        // FakeUNNotification should have the data from above now
        let notification = FakeUNNotification.new
        let content = FakeUNNotificationContent()
        content.userInfo = [
            "aps": [
                "alert": [
                    "title": expectedTitle,
                    "body": expectedMessage
                ]
            ],
            "landmarkId": expectedLandmarkId,
            "landmarkImage": "silversalmoncreek"
        ]
        notification.request = UNNotificationRequest(identifier: "", content: content, trigger: nil)
        notificationController.didReceive(notification)

        let body = notificationController.body

        XCTAssertEqual(body.title, expectedTitle)
        XCTAssertEqual(body.message, expectedMessage)
        XCTAssertEqual(body.landmarkId, expectedLandmarkId)
        XCTAssertEqual(body.landmarkImage, expectedLandmarkImage)
    }
}
