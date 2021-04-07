//
//  FakeUNNotification.swift
//  WatchLandmarks_FrameworkTests
//
//  Created by thompsty on 4/7/21.
//

import Foundation
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
