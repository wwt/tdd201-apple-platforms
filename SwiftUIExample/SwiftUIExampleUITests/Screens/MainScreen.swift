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

    var hasMap: Bool {
        XCUIApplication.current.maps.firstMatch.exists
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

    static var goalDateFormatted: Bool {
        let goalDatePredicate = NSPredicate(format: "label BEGINSWITH 'Goal Date: '")
        let goalDateLabel = XCUIApplication.current.staticTexts.element(matching: goalDatePredicate)
        let dateString = goalDateLabel.label.matches(for: "^Goal Date: (.*)$").last ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"

        return goalDateLabel.exists && dateFormatter.date(from: dateString) != nil
    }
}

enum LandmarksScreen {
    static var isVisible: Bool {
        XCUIApplication.current.navigationBars.firstMatch.identifier == "Landmarks"
    }

    @discardableResult static func goToLandmark(_ landmark: Landmarks) -> LandmarkDetailScreen {
        XCUIApplication.current.tables.buttons[landmark.rawValue].tap()
        return LandmarkDetailScreen(landmark: landmark)
    }
}

extension XCUIApplication {
    static let current: XCUIApplication = XCUIApplication()
}
