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

@testable import WatchLandmarks_Framework
import UserNotifications

@objc(FakeUNNotification) class FakeUNNotification: UNNotification {

    // swiftlint:disable force_cast
    static var new: FakeUNNotification {
        // dark arts way to call a private initializer
        return (objc_getClass("FakeUNNotification") as! NSObject)
            .perform(NSSelectorFromString("new"))
            .takeRetainedValue() as! FakeUNNotification
    }
    // swiftlint:enable force_cast

    private var _date: Date!
    override var date: Date {
        get { _date }
        set { _date = newValue }
    }

    private var _request: UNNotificationRequest = UNNotificationRequest(identifier: "WRONG",
                                                                        content: UNNotificationContent(),
                                                                        trigger: nil)
    override var request: UNNotificationRequest {
        get { _request }
        set { _request = newValue }
    }
}

class FakeUNNotificationContent: UNNotificationContent {
    var _userInfo: [AnyHashable: Any]!
    override var userInfo: [AnyHashable: Any] {
        get { _userInfo }
        set { _userInfo = newValue }
    }
}

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
