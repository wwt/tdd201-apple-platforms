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

@testable import SwiftUIExample

class FavoriteButtonTests: XCTestCase {
    func testFavoriteButtonNotSetIsDisplayedCorrectly() throws {
        let expectedImage = Image(systemName: "star")
        let favoriteButton = FavoriteButton(isSet: .constant(false))
        let button = try favoriteButton.inspect().find(ViewType.Button.self)
        let buttonImage = try button.labelView().find(ViewType.Image.self)

        XCTAssertEqual(try buttonImage.actualImage(), expectedImage)
        XCTAssertEqual(try buttonImage.foregroundColor(), Color.gray)
    }

    func testFavoriteButtonSetIsDisplayedCorrectly() throws {
        let expectedImage = Image(systemName: "star.fill")
        let favoriteButton = FavoriteButton(isSet: .constant(true))
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
