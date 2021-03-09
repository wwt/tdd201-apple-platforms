//
//  MainScreen.swift
//  SwiftUIExampleUITests
//
//  Created by Heather Meadow on 2/25/21.
//

import Foundation
import XCTest
import SwiftUIExample

enum MainScreen {
    @discardableResult static func navigateToCategoryHome() -> Self.Type {
        XCUIApplication.current.tabBars["Tab Bar"].buttons["Featured"].tap()
        return Self.self
    }

    @discardableResult static func navigateToLandmarksList() -> Self.Type {
        XCUIApplication.current.tabBars["Tab Bar"].buttons["List"].tap()
        return Self.self
    }
}
