//
//  UNNotificationTests.swift
//  MockingFrameworkTests
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation
import XCTest

class UNNotificaitonTests: XCTestCase {

    func testMockUNNotification() throws {
        let notification = MockUNNotification.new
        let now = Date()

        notification.date = now

        XCTAssertEqual(notification.date, now)
    }
}
