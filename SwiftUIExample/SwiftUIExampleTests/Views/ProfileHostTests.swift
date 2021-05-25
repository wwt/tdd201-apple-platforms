//
//  ProfileHostTests.swift
//  SwiftUIExampleTests
//
//  Created by david.roff on 5/25/21.
//

import Foundation
import SwiftUI
import ViewInspector
import XCTest

@testable import SwiftUIExample

class ProfileHostTests: XCTestCase {
    func testWhenNotEditing() throws {
        let exp = ViewHosting.loadView(ProfileHost(), data: AppModel(), keyPath: \.editMode, keyValue: .constant(.inactive)).inspection.inspect { profileHost in
            XCTAssertThrowsError(try profileHost.find(ViewType.Button.self))
            XCTAssertNoThrow(try profileHost.find(ViewType.EditButton.self))
            XCTAssertThrowsError(try profileHost.find(ProfileEditor.self))
            XCTAssertNoThrow(try profileHost.find(ProfileSummary.self))
        }
        wait(for: [exp], timeout: 0.5)
    }

    func testWhenEditing() throws {
        let expectedProfile = Profile(username: "test")
        let appModel = AppModel()
        appModel.profile = expectedProfile
        let exp = ViewHosting.loadView(ProfileHost(), data: appModel, keyPath: \.editMode, keyValue: .constant(.active)).inspection.inspect { profileHost in
            let button = XCTAssertNoThrowAndAssign(try profileHost.find(ViewType.Button.self))

            XCTAssertEqual(try button?.labelView().text().string(), "Cancel")
            XCTAssertNoThrow(try profileHost.find(ViewType.EditButton.self))
            XCTAssertThrowsError(try profileHost.find(ProfileSummary.self))

            let profileEditor = XCTAssertNoThrowAndAssign(try profileHost.find(ProfileEditor.self))
            try profileEditor?.callOnAppear()

            XCTAssertEqual(try profileEditor?.actualView().profile, expectedProfile)
        }
        wait(for: [exp], timeout: 0.5)
    }

    func testWhenCancelledEditing() throws {
        let expectedProfile = Profile(username: "test")
        let appModel = AppModel()
        let expectedEditMode = Binding<EditMode>(wrappedValue: .active)
        appModel.profile = expectedProfile
        let exp = ViewHosting.loadView(ProfileHost(), data: appModel, keyPath: \.editMode, keyValue: expectedEditMode).inspection.inspect { profileHost in
            let button = XCTAssertNoThrowAndAssign(try profileHost.find(ViewType.Button.self))
            let profileEditor = XCTAssertNoThrowAndAssign(try profileHost.find(ProfileEditor.self))
            try profileEditor?.actualView().$profile.wrappedValue.username = "new username"
            try button?.tap()

            XCTAssertEqual(expectedEditMode.wrappedValue, .inactive)
            XCTAssertEqual(appModel.profile, expectedProfile)
        }
        wait(for: [exp], timeout: 0.5)
    }

    func testProfileSavedWhenProfileEditorDisappears() throws {
        let expectedProfile = Profile(username: "new username")
        let appModel = AppModel()
        appModel.profile = Profile(username: "test")
        let exp = ViewHosting.loadView(ProfileHost(), data: appModel, keyPath: \.editMode, keyValue: .constant(.active)).inspection.inspect { profileHost in

            let profileEditor = XCTAssertNoThrowAndAssign(try profileHost.find(ProfileEditor.self))
            try profileEditor?.callOnAppear()
            try profileEditor?.actualView().$profile.wrappedValue = expectedProfile
            try profileEditor?.callOnDisappear()

            XCTAssertEqual(try profileEditor?.actualView().profile, expectedProfile)
        }
        wait(for: [exp], timeout: 0.5)
    }
}
