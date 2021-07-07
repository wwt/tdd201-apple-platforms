//
//  CircleImageTests.swift
//  SwiftUIExampleTests
//
//  Created by Zach Frew on 5/21/21.
//

import ViewInspector
import XCTest
import SwiftUI
@testable import SwiftUIExample

class CircleImageTests: XCTestCase {
    func testCircleImageIsCircular() throws {
        let expectedImage = Image("turtlerock")
        let circleImage = try CircleImage(image: expectedImage).inspect()
        let image = try circleImage.find(ViewType.Image.self)

        XCTAssertNoThrow(try image.clipShape(Circle.self))
        XCTAssertEqual(try image.actualImage(), expectedImage)
    }
}
