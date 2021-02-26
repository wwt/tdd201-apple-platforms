//
//  MainScreen.swift
//  SwiftUIExampleUITests
//
//  Created by Heather Meadow on 2/25/21.
//

import Foundation
import XCTest

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

enum Landmarks: String {
    case silverSalmonCreek = "Silver Salmon Creek"
}

struct LandmarkDetailScreen {
    let landmark: Landmarks

    var isVisible: Bool {
        XCUIApplication.current.navigationBars.firstMatch.identifier == landmark.rawValue
    }
}

enum FeaturedScreen {
    static var isVisible: Bool {
        XCUIApplication.current.navigationBars.firstMatch.identifier == "Featured"
    }

    @discardableResult static func goToLandmark(_ landmark: Landmarks) -> LandmarkDetailScreen {
        XCUIApplication.current.tables.buttons[landmark.rawValue].tap()
        return LandmarkDetailScreen(landmark: landmark)
    }

    @discardableResult static func goToProfile() -> ProfileScreen.Type {
        XCUIApplication.current.navigationBars["Featured"].buttons["account"].tap()
        return ProfileScreen.self
    }
}

enum ProfileScreen {
    static var isVisible: Bool {
        XCUIApplication.current.staticTexts["g_kumar"].exists
    }
}

enum LandmarksScreen {
    static var isVisible: Bool {
        XCUIApplication.current.navigationBars.firstMatch.identifier == "Landmarks"
    }
}

extension XCUIApplication {
    static let current: XCUIApplication = XCUIApplication()
}
