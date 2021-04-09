//
//  FavoriteButtonTests.swift
//  SwiftUIExampleTests
//
//  Created by Richard Gist on 4/9/21.
//

import XCTest
import SwiftUI
import ViewInspector

@testable import SwiftUIExample

class FavoriteButtonTests: XCTestCase {
    func testFavoriteButtonNotSetIsDisplayedCorrectly() throws {
        let expectedImage = Image(systemName: "star")

        let favoriteButton = FavoriteButton(isSet: .constant(false))

        let button = XCTAssertNoThrowAndAssign(try favoriteButton.inspect().find(ViewType.Button.self))
        let buttonImage = XCTAssertNoThrowAndAssign(try button?.labelView().find(ViewType.Image.self))
        XCTAssertEqual(try buttonImage?.actualImage(), expectedImage)
        XCTAssertEqual(try buttonImage?.foregroundColor(), Color.gray)
    }

    func testFavoriteButtonSetIsDisplayedCorrectly() throws {
        let expectedImage = Image(systemName: "star.fill")

        let favoriteButton = FavoriteButton(isSet: .constant(true))

        let button = XCTAssertNoThrowAndAssign(try favoriteButton.inspect().find(ViewType.Button.self))
        let buttonImage = XCTAssertNoThrowAndAssign(try button?.labelView().find(ViewType.Image.self))
        XCTAssertEqual(try buttonImage?.actualImage(), expectedImage)
        XCTAssertEqual(try buttonImage?.foregroundColor(), Color.yellow)
    }

    func testTappingButtonTogglesImage() throws {
        let expectedImage = Image(systemName: "star.fill")
        let binding = Binding<Bool>(wrappedValue: false)
        let favoriteButton = FavoriteButton(isSet: binding)
        let button = XCTAssertNoThrowAndAssign(try favoriteButton.inspect().find(ViewType.Button.self))

        try button?.tap()

        let buttonImage = XCTAssertNoThrowAndAssign(try favoriteButton.inspect()
            .find(ViewType.Button.self).labelView()
            .find(ViewType.Image.self))
        XCTAssert(favoriteButton.isSet)
        XCTAssertEqual(try buttonImage?.actualImage(), expectedImage)
        XCTAssertEqual(try buttonImage?.foregroundColor(), Color.yellow)
    }
}
