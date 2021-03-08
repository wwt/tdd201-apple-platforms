//
//  FeaturedScreen.swift
//  SwiftUIExampleUITests
//
//  Created by Heather Meadow on 3/8/21.
//

import Foundation
import XCTest
import SwiftUIExample

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
