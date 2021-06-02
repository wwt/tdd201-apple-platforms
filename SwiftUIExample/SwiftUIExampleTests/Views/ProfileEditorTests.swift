//
//  ProfileEditorTests.swift
//  SwiftUIExampleTests
//
//  Created by david.roff on 5/25/21.
//

import Fakery
import Foundation
import SwiftUI
import ViewInspector
import XCTest

@testable import SwiftUIExample

class ProfileEditorTests: XCTestCase {
    func testProfileEditor() throws {
        let expectedProfile = Profile(username: Faker().internet.username(),
                                      prefersNotifications: true,
                                      seasonalPhoto: Profile.Season.allCases.randomElement()!,
                                      goalDate: Faker().date.forward(5))
        let profileEditor = try ProfileEditor(profile: .constant(expectedProfile)).inspect()

        XCTAssertEqual(try profileEditor.find(ViewType.Text.self, traversal: .depthFirst).string(), "Username")
        XCTAssertEqual(try profileEditor.find(ViewType.TextField.self).labelView().text().string(), "Username")
        XCTAssertEqual(try profileEditor.find(ViewType.TextField.self).input(), expectedProfile.username)
        XCTAssertEqual(try profileEditor.find(ViewType.Toggle.self).labelView().text().string(), "Enable Notifications")
        XCTAssert(try profileEditor.find(ViewType.Toggle.self).isOn())
        XCTAssertEqual(try profileEditor.find(ViewType.Text.self, skipFound: 3).string(), "Seasonal Photo")

        let picker = try profileEditor.find(ViewType.Picker.self)

        XCTAssertEqual(try picker.labelView().text().string(), "Seasonal Photo")
        XCTAssertEqual(try picker.forEach(0).count, Profile.Season.allCases.count)

        try picker.forEach(0).enumerated().forEach {
            XCTAssertEqual(try $0.element.text().string(), Profile.Season.allCases[$0.offset].rawValue)
            XCTAssertEqual(try $0.element.text().tag(), Profile.Season.allCases[$0.offset])
        }

        let datePicker = try profileEditor.find(ViewType.DatePicker.self)

        XCTAssertEqual(try datePicker.labelView().text().string(), "Goal Date")
    }

    func testEditingProfileValuesUpdatesProfile() throws {
        let profileEditor = try ProfileEditor(profile: Binding(wrappedValue: .default)).inspect()

        let toggle = try profileEditor.find(ViewType.Toggle.self)
        let expectedToggleValue = false
        try toggle.tap()

        let picker = try profileEditor.find(ViewType.Picker.self)
        let expectedSeason = Profile.Season.summer
        try picker.select(value: expectedSeason)

        let datePicker = try profileEditor.find(ViewType.DatePicker.self)
        let expectedDate = Date().advanced(by: 7)
        try datePicker.select(date: expectedDate)

        let textField = try profileEditor.find(ViewType.TextField.self)
        let expectedUsername = "Ron Burgundy"
        try textField.setInput(expectedUsername)

        XCTAssertEqual(try profileEditor.actualView().profile.prefersNotifications, expectedToggleValue)
        XCTAssertEqual(try profileEditor.actualView().profile.seasonalPhoto, expectedSeason)
        XCTAssertEqual(try profileEditor.actualView().profile.goalDate, expectedDate)
        XCTAssertEqual(try profileEditor.actualView().profile.username, expectedUsername)
    }
}
