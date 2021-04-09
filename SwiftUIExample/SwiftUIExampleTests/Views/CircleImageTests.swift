//
//  CircleImageTests.swift
//  SwiftUIExampleTests
//
//  Created by Richard Gist on 4/9/21.
//

import XCTest
import SwiftUI
import ViewInspector

@testable import SwiftUIExample

class CircleImageTests: XCTestCase {
    func testCircleImageDisplaysImageCorrectly() throws {
        let expectedImage = Image("turtlerock")

        let circleImage = try CircleImage(image: expectedImage).inspect()

        let image = XCTAssertNoThrowAndAssign(try circleImage.find(ViewType.Image.self))
        XCTAssertNoThrow(try image?.clipShape(Circle.self))
        XCTAssertEqual(try image?.actualImage(), expectedImage)
    }
}
