//
//  FakeUNNotification.swift
//  MockingFrameworkTests
//
//  Created by Heather Meadow on 2/10/21.
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

}
