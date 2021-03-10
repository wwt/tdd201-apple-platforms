//
//  ProfileHostTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/25/21.
//

import Foundation
import XCTest
import SwiftUI
import Fakery
import ViewInspector

@testable import SwiftUIExample

class ProfileHostTests: XCTestCase {
    func testProfileHostActiveEditMode() throws {
        let expectedProfile = Profile(username: "not the default username")
        let appModel = AppModel()
        appModel.profile = expectedProfile
        let exp = ViewHosting.loadView(ProfileHost(), data: appModel, keyPath: \.editMode, keyValue: .constant(.active)).inspection.inspect { (view) in
            XCTAssertEqual(try view.find(ViewType.Button.self).labelView().text().string(), "Cancel")
            XCTAssertNoThrow(try view.find(ViewType.EditButton.self))
            XCTAssertThrowsError(try view.vStack().view(ProfileSummary.self, 1))
            let profileEditor = try view.find(ProfileEditor.self)
            XCTAssertEqual(try profileEditor.actualView().profile, expectedProfile)
            try profileEditor.actualView().$profile.wrappedValue.username = "A new name"
            try profileEditor.callOnDisappear()

            XCTAssertEqual(appModel.profile.username, "A new name")
        }

        wait(for: [exp], timeout: 3.0)
    }

    func testProfileHostInactiveEditMode() throws {
        let appModel = AppModel()
        let exp = ViewHosting.loadView(ProfileHost(), data: appModel, keyPath: \.editMode, keyValue: .constant(.inactive)).inspection.inspect { (view) in
            XCTAssertThrowsError(try view.vStack().hStack(0).button(0))
            XCTAssertNoThrow(try view.vStack().hStack(0).editButton(2))
            XCTAssertThrowsError(try view.vStack().view(ProfileEditor.self, 1))
            XCTAssertNoThrow(try view.vStack().view(ProfileSummary.self, 1))
        }

        wait(for: [exp], timeout: 3.0)
    }

    func testProfileHostCancelsEditing() throws {
        let bindingEditMode = Binding<EditMode>(wrappedValue: .active)
        let expectedProfile = Profile(username: "not the default username")
        let appModel = AppModel()
        appModel.profile = expectedProfile
        let exp = ViewHosting.loadView(ProfileHost(), data: appModel, keyPath: \.editMode, keyValue: bindingEditMode).inspection.inspect { (view) in
            try view.actualView().draftProfile.username = "different"
            try view.find(ViewType.Button.self).tap()

            XCTAssertEqual(try view.actualView().draftProfile, expectedProfile)
            XCTAssertEqual(bindingEditMode.wrappedValue, .inactive)
        }

        wait(for: [exp], timeout: 3.0)
    }
}

extension Profile: Equatable {

    public static func == (lhs: Profile, rhs: Profile) -> Bool {
        lhs.username == rhs.username
            && lhs.prefersNotifications == rhs.prefersNotifications
            && lhs.seasonalPhoto == rhs.seasonalPhoto
            && lhs.goalDate == rhs.goalDate
    }
}
