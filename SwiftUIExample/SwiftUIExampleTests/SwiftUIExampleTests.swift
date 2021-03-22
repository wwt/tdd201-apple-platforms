//
//  SwiftUIExampleTests.swift
//  SwiftUIExampleTests
//
//  Created by thompsty on 1/19/21.
//

import XCTest
import Swinject

@testable import SwiftUIExample

class SwiftUIExampleTests: XCTestCase {
    func testDependenciesAreSetup() throws {
        _ = SwiftUIExampleApp()

        XCTAssert(Container.default.resolve(HikesServiceProtocol.self) is API.HikesService, "Expected API.HikesService to be registered inside container")
    }
}
