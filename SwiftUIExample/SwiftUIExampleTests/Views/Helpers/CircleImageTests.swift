//
//  CircleImageTests.swift
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

extension CircleImage: Inspectable { }

class CircleImageTests: XCTestCase {

    func testUILooksAsExpected() throws {
        let expectedImage = Image("turtlerock")
        let view = CircleImage(image: expectedImage)
        assertSnapshot(matching: view, as: .image(precision: 0.99))
    }

    func testCircleImageDisplaysImageCorrectly() throws {
        let expectedImage = Image("turtlerock")
        let circleImage = try CircleImage(image: expectedImage).inspect()
        let image = try circleImage.find(ViewType.Image.self)

        XCTAssertNoThrow(try image.clipShape(Circle.self))
        XCTAssertEqual(try image.actualImage(), expectedImage)
    }
}
