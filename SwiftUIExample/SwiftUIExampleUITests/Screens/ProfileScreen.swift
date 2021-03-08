//
//  ProfileScreen.swift
//  SwiftUIExampleUITests
//
//  Created by Heather Meadow on 3/8/21.
//

import Foundation
import XCTest
import SwiftUIExample

enum ProfileScreen {
    enum GraphType: String {
        case elevation = "Elevation"
        case heartRate = "Heart Rate"
        case pace = "Pace"
    }
    static var isVisible: Bool {
        XCUIApplication.current.staticTexts["Completed Badges"].exists
    }

    static var elevationGraphVisible: Bool {
        XCUIApplication.current.buttons[GraphType.elevation.rawValue].isSelected
    }

    static var heartRateGraphVisible: Bool {
        XCUIApplication.current.buttons[GraphType.heartRate.rawValue].isSelected
    }

    static var paceGraphVisible: Bool {
        XCUIApplication.current.buttons[GraphType.pace.rawValue].isSelected
    }

    static var goalDateFormatted: Bool {
        let goalDatePredicate = NSPredicate(format: "label BEGINSWITH 'Goal Date: '")
        let goalDateLabel = XCUIApplication.current.staticTexts.element(matching: goalDatePredicate)
        let dateString = goalDateLabel.label.matches(for: "^Goal Date: (.*)$").last ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"

        return goalDateLabel.exists && dateFormatter.date(from: dateString) != nil
    }

    static func usernameMatches(_ username: String) -> Bool {
        let expectation = XCTNSPredicateExpectation(predicate:
                            NSPredicate(format: "exists == true"),
                            object: XCUIApplication.current.staticTexts[username])
        let result = XCTWaiter.wait(for: [expectation], timeout: 5)
        return result == .completed
    }

    @discardableResult static func goToEditProfile() -> ProfileEditScreen.Type {
        XCUIApplication.current.buttons["Edit"].tap()
        return ProfileEditScreen.self
    }

    @discardableResult static func toggleHikeGraph() -> ProfileEditScreen.Type {
        XCUIApplication.current.buttons["chevron.right.circle"].tap()
        return ProfileEditScreen.self
    }

    @discardableResult static func changeGraph(to type: GraphType) -> ProfileEditScreen.Type {
        XCUIApplication.current.buttons[type.rawValue].tap()
        return ProfileEditScreen.self
    }
}
