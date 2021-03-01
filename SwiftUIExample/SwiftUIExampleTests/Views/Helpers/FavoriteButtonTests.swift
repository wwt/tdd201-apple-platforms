//
//  FavoriteButtonTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/22/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector
import SnapshotTesting

@testable import SwiftUIExample

extension FavoriteButton: Inspectable { }

class FavoriteButtonTests: XCTestCase {

    func testUILooksAsExpected() throws {
        let view = FavoriteButton(isSet: Binding<Bool>(wrappedValue: true))
        assertSnapshot(matching: view, as: .image(precision: 0.99))
    }

    func testFavoriteButtonNotSetIsDisplayedCorrectly() throws {
        let expectedImage = Image(systemName: "star")
        let binding = Binding<Bool>(wrappedValue: false)
        let favoriteButton = FavoriteButton(isSet: binding)
        let button = try favoriteButton.inspect().find(ViewType.Button.self)
        let buttonImage = try button.labelView().find(ViewType.Image.self)

        XCTAssertEqual(try buttonImage.actualImage(), expectedImage)
        XCTAssertEqual(try buttonImage.foregroundColor(), Color.gray)
    }

    func testFavoriteButtonSetIsDisplayedCorrectly() throws {
        let expectedImage = Image(systemName: "star.fill")
        let binding = Binding<Bool>(wrappedValue: true)
        let favoriteButton = FavoriteButton(isSet: binding)
        let button = try favoriteButton.inspect().find(ViewType.Button.self)
        let buttonImage = try button.labelView().find(ViewType.Image.self)

        XCTAssertEqual(try buttonImage.actualImage(), expectedImage)
        XCTAssertEqual(try buttonImage.foregroundColor(), Color.yellow)
    }

    func testTappingButtonTogglesImage() throws {
        let expectedImage = Image(systemName: "star.fill")
        let binding = Binding<Bool>(wrappedValue: false)
        let favoriteButton = FavoriteButton(isSet: binding)
        let button = try favoriteButton.inspect().find(ViewType.Button.self)

        try button.tap()

        let buttonImage = try favoriteButton.inspect()
            .find(ViewType.Button.self).labelView()
            .find(ViewType.Image.self)
        XCTAssert(favoriteButton.isSet)
        XCTAssertEqual(try buttonImage.actualImage(), expectedImage)
        XCTAssertEqual(try buttonImage.foregroundColor(), Color.yellow)
    }

}
