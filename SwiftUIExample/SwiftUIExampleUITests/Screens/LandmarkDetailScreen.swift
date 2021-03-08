//
//  LandmarkDetailScreen.swift
//  SwiftUIExampleUITests
//
//  Created by Heather Meadow on 3/8/21.
//

import Foundation
import XCTest
import SwiftUIExample

enum Landmarks: String {
    case silverSalmonCreek = "Silver Salmon Creek"
    case turtleRock = "Turtle Rock"
}

struct LandmarkDetailScreen {
    let landmark: Landmarks

    var isVisible: Bool {
        XCUIApplication.current.navigationBars.firstMatch.identifier == landmark.rawValue
    }

    var hasMap: Bool {
        XCUIApplication.current.maps.firstMatch.exists
    }

    var isFavorite: Bool {
        XCUIApplication.current.buttons["star.fill"].exists
            && !XCUIApplication.current.buttons["star"].exists
    }

    @discardableResult func toggleFavorite() -> LandmarkDetailScreen {
        if isFavorite {
            XCUIApplication.current.buttons["star.fill"].tap()
        } else {
            XCUIApplication.current.buttons["star"].tap()
        }
        return self
    }
}
