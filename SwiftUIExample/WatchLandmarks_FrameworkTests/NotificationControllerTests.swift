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
        notificationController.didReceive(FakeUNNotification.new)

        let body = notificationController.body

        XCTAssertEqual(body.title, expectedTitle)
        XCTAssertEqual(body.message, expectedMessage)
        XCTAssertEqual(body.landmarkId, expectedLandmarkId)
        XCTAssertEqual(body.landmarkImage, expectedLandmarkImage)
    }
}

