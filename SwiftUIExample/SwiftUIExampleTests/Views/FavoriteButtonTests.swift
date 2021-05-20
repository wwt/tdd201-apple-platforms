//
//  FavoriteButtonTests.swift
//  SwiftUIExampleTests
//
//  Created by Zach Frew on 5/20/21.
//

import SwiftUI
import ViewInspector
import XCTest
@testable import SwiftUIExample

class FavoriteButtonTests: XCTestCase {
    func testFavoriteButtonNotSetIsDisplayedCorrectly() throws {
        let expectedImage = Image(systemName: "star")
        let favoriteButton = FavoriteButton(isSet: .constant(false))
        let button = try favoriteButton.inspect().find(ViewType.Button.self)
        let buttonImage = try button.labelView().find(ViewType.Image.self)

        XCTAssertEqual(try buttonImage.actualImage(), expectedImage)
        XCTAssertEqual(try buttonImage.foregroundColor(), .gray)
    }

    func testFavoriteButtonSetIsDisplayedCorrectly() throws {
        let expectedImage = Image(systemName: "star.fill")
        let favoriteButton = FavoriteButton(isSet: .constant(true))
        let button = try favoriteButton.inspect().find(ViewType.Button.self)
        let buttonImage = try button.labelView().find(ViewType.Image.self)

        XCTAssertEqual(try buttonImage.actualImage(), expectedImage)
        XCTAssertEqual(try buttonImage.foregroundColor(), .yellow)
    }

    func testTappingButtonTogglesImage() throws {
        let expectedImage = Image(systemName: "star")
        let binding = Binding(wrappedValue: true)
        let favoriteButton = FavoriteButton(isSet: binding)
        let button = try favoriteButton.inspect().find(ViewType.Button.self)

        try button.tap()

        let buttonImage = try favoriteButton.inspect().find(ViewType.Button.self)
            .labelView().find(ViewType.Image.self)

        XCTAssertEqual(try buttonImage.actualImage(), expectedImage)
        XCTAssertEqual(try buttonImage.foregroundColor(), .gray)
        XCTAssertFalse(favoriteButton.isSet)
    }
}
