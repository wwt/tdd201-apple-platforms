//
//  UserTests.swift
//  DependencyInjectionTests
//
//  Created by Heather Meadow on 2/1/21.
//

import Foundation
import XCTest

@testable import DependencyInjection

class UserTests: XCTestCase {

    func testUserCanBeInitialized() {
        let expectedID = 10
        let expectedFirstName = UUID().uuidString
        let expectedLastName = UUID().uuidString
        let user = User(id: expectedID, firstName: expectedFirstName, lastName: expectedLastName)

        XCTAssertEqual(user.id, expectedID)
        XCTAssertEqual(user.firstName, expectedFirstName)
        XCTAssertEqual(user.lastName, expectedLastName)

    }
}
