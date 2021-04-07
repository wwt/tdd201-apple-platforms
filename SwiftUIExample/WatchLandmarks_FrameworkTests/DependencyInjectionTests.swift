//
//  DependencyInjectionTests.swift
//  WatchLandmarks_FrameworkTests
//
//  Created by thompsty on 4/7/21.
//

import Foundation
import XCTest
import Swinject

@testable import WatchLandmarks_Framework

class DependencyInjectionTests: XCTestCase {
    func testNotificationResponderIsRegisteredOnAppStart() throws {
        _ = SwiftUIExampleApp()

        XCTAssertNotNil(Container.default.resolve(NotificationRespondable.self))
        XCTAssert(Container.default.resolve(NotificationRespondable.self) is TestableNotificationController)
    }

}
