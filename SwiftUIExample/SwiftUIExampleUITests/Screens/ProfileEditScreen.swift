//
//  ProfileEditScreen.swift
//  SwiftUIExampleUITests
//
//  Created by Heather Meadow on 3/8/21.
//

import Foundation
import XCTest
import SwiftUIExample

enum ProfileEditScreen {
    enum Season: String {
        case spring = "🌷"
        case summer = "🌞"
        case autumn = "🍂"
        case winter = "☃️"
    }

    static var isVisible: Bool {
        XCUIApplication.current.textFields["Username"].exists
    }

    static var notificationsEnabled: Bool {
        (XCUIApplication.current.switches.firstMatch.value as? String) == "1"
    }

    @discardableResult static func toggleNotifications() -> Self.Type {
        XCUIApplication.current.switches.firstMatch.tap()
        return Self.self
    }

    @discardableResult static func cancelEditing() -> ProfileScreen.Type {
        XCUIApplication.current.buttons["Cancel"].tap()
        return ProfileScreen.self
    }

    @discardableResult static func finishEditing() -> ProfileScreen.Type {
        XCUIApplication.current.buttons["Done"].tap()
        return ProfileScreen.self
    }

    @discardableResult static func changeUsername(to username: String) -> Self.Type {
        let textField = XCUIApplication.current.textFields["Username"]
        textField.textFieldElement?.clearAndEnterText(username)
        return Self.self
    }

    static func usernameMatches(_ username: String) -> Bool {
        (XCUIApplication.current.textFields["Username"].value as? String) == username
    }

    @discardableResult static func changeSeasonalPhoto(to photo: Season) -> Self.Type {
        XCUIApplication.current.buttons[photo.rawValue].tap()
        return Self.self
    }

    static func seasonalPhotoMatches(_ photo: Season) -> Bool {
        XCUIApplication.current.buttons[photo.rawValue].isSelected
    }

    @discardableResult static func changeGoalDate(to date: Date?) -> Self.Type {
        guard let date = date else {
            return Self.self
        }
        XCUIApplication.current.datePickers.firstMatch.tap()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        XCUIApplication.current.datePickers.collectionViews.buttons[formatter.string(from: date)].tap()
        XCUIApplication.current.textFields["Username"].tap()
        return Self.self
    }

    static func goalDateMatches(_ date: Date?) -> Bool {
        guard let date = date else {
            XCTFail("You should pass in a real date to check")
            return false
        }
        let predicate = NSPredicate(format: "value ENDSWITH 'Collapsed'")
        let value = XCUIApplication.current.datePickers.firstMatch.otherElements.element(matching: predicate).value as? String
        let dateString = value?.matches(for: "^(.*?), (.*?), Collapsed$").last ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"

        return dateString == dateFormatter.string(from: date)
    }

}
