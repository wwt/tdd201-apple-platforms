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
        XCUIApplication.current.staticTexts["Completed Badges"].exists
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
}

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
        (XCUIApplication.current.switches["Enable Notifications"].value as? String) == "1"
    }

    @discardableResult static func toggleNotifications() -> Self.Type {
        XCUIApplication.current.switches["Enable Notifications"].tap()
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

struct TextFieldElement {
    let wrapped: XCUIElement
    private let stringValue: String

    init?(with element: XCUIElement) {
        guard let value = element.value as? String else { return nil }
        wrapped = element
        stringValue = value
    }

    func clearText() {
        // workaround for apple bug
        if let placeholderString = wrapped.placeholderValue, placeholderString == stringValue {
            return
        }
        wrapped.tap()
        let deleteText = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        wrapped.typeText(deleteText)
    }

    func clearAndEnterText(_ text: String) {
        clearText()
        wrapped.tap()
        wrapped.typeText(text)
    }
}

extension XCUIElement {

    var textFieldElement: TextFieldElement? {
        TextFieldElement(with: self)
    }
}
