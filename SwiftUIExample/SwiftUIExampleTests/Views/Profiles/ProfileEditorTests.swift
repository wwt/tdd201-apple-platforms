//
//  ProfileEditorTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/25/21.
//

import Foundation
import XCTest
import SwiftUI
import Fakery
import ViewInspector
import SnapshotTesting

@testable import SwiftUIExample

class ProfileEditorTests: XCTestCase {
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        let expectedProfile = Profile(username: "user1",
                                      prefersNotifications: true,
                                      seasonalPhoto: .autumn,
                                      goalDate: Date(timeIntervalSince1970: 1614627432))
        let bindingProfile = Binding<Profile>(wrappedValue: expectedProfile)
        let view = ProfileEditor(profile: bindingProfile)
        assertSnapshot(matching: view, as: .image)
    }

    func testProfileEditor() throws {
        let expectedProfile = Profile(username: Faker().internet.username(),
                                      prefersNotifications: true,
                                      seasonalPhoto: Profile.Season.allCases.randomElement() ?? .autumn,
                                      goalDate: Faker().date.forward(5))
        let bindingProfile = Binding<Profile>(wrappedValue: expectedProfile)
        let profileEditor = try ProfileEditor(profile: bindingProfile).inspect()

        XCTAssertEqual(try profileEditor.find(ViewType.Text.self, index: 0).string(), "Username")
        XCTAssertEqual(try profileEditor.find(ViewType.TextField.self).labelView().text().string(), "Username")
        XCTAssertEqual(try profileEditor.find(ViewType.TextField.self).input(), expectedProfile.username)

        XCTAssertEqual(try profileEditor.find(ViewType.Text.self, index: 2).string(), "Enable Notifications")
        XCTAssertEqual(try profileEditor.find(ViewType.Text.self, index: 3).string(), "Seasonal Photo")

        let picker = try profileEditor.find(ViewType.Picker.self)
        XCTAssertEqual(try picker.labelView().text().string(), "Seasonal Photo")
        XCTAssertEqual(try picker.forEach(0).count, Profile.Season.allCases.count)
        try picker.forEach(0).enumerated().forEach {
            XCTAssertEqual(try $0.element.text().string(), Profile.Season.allCases[$0.offset].rawValue)
            XCTAssertEqual(try $0.element.text().tag(), Profile.Season.allCases[$0.offset])
        }
        #warning("Have to test binding in XCUITests")
        XCTAssertEqual(try profileEditor.find(ViewType.DatePicker.self).labelView().text().string(), "Goal Date")
    }

    func testToggleIsBoundToProfileNotifications() throws {
        let expectedProfile = Profile(username: Faker().internet.username(),
                                      prefersNotifications: true,
                                      seasonalPhoto: Profile.Season.allCases.randomElement() ?? .autumn,
                                      goalDate: Faker().date.forward(5))
        let bindingProfile = Binding<Profile>(wrappedValue: expectedProfile)
        let profileEditor = ProfileEditor(profile: bindingProfile)

        XCTAssert(try profileEditor.inspect().find(ViewType.Toggle.self).isOn())

        try profileEditor.inspect().find(ViewType.Toggle.self).tap()

        XCTAssertFalse(try profileEditor.inspect().find(ViewType.Toggle.self).isOn())
    }

    func testPickerIsBoundToProfileSeasonalPhoto() throws {
        let expectedProfile = Profile(username: Faker().internet.username(),
                                      prefersNotifications: true,
                                      seasonalPhoto: .autumn,
                                      goalDate: Faker().date.forward(5))
        let bindingProfile = Binding<Profile>(wrappedValue: expectedProfile)
        let profileEditor = ProfileEditor(profile: bindingProfile)
        let picker = try profileEditor.inspect().find(ViewType.Picker.self)

        try picker.select(value: Profile.Season.summer)

        XCTAssertEqual(bindingProfile.wrappedValue.seasonalPhoto, .summer)
    }

}
