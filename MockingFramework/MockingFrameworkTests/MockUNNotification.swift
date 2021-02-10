//
//  MockUNNotification.swift
//  MockingFrameworkTests
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation
import UserNotifications

@objc(MockUNNotification) class MockUNNotification: UNNotification {

    // swiftlint:disable force_cast
    static var new: MockUNNotification {
        // dark arts way to call a private initializer
        return (objc_getClass("MockUNNotification") as! NSObject)
            .perform(NSSelectorFromString("new"))
            .takeRetainedValue() as! MockUNNotification
    }
    // swiftlint:enable force_cast
    private var _date: Date!
    override var date: Date {
        get { _date }
        set { _date = newValue }
    }

}
