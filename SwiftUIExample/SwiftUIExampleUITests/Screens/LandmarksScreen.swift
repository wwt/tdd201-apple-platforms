//
//  LandmarksScreen.swift
//  SwiftUIExampleUITests
//
//  Created by Heather Meadow on 3/8/21.
//

import Foundation
import XCTest
import SwiftUIExample

enum LandmarksScreen {
    static var isVisible: Bool {
        XCUIApplication.current.navigationBars.firstMatch.identifier == "Landmarks"
    }

    static var isFavoritesOnly: Bool {
        (XCUIApplication.current.switches.firstMatch.value as? String) == "1"
    }

    static var landmarksInList: Int {
        XCUIApplication.current.tables.firstMatch.cells.count
    }

    @discardableResult static func goToLandmark(_ landmark: Landmarks) -> LandmarkDetailScreen {
        XCUIApplication.current.tables.buttons[landmark.rawValue].tap()
        return LandmarkDetailScreen(landmark: landmark)
    }

    @discardableResult static func toggleFavorites() -> Self.Type {
        XCUIApplication.current.switches.firstMatch.tap()
        return Self.self
    }
}
