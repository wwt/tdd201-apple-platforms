//
//  ContractTests.swift
//  ContractTestingTests
//
//  Created by thompsty on 2/16/21.
//

import Foundation
import XCTest
import PactConsumerSwift
import Fakery
import OHHTTPStubs

@testable import ContractTesting

class ContractTests: XCTestCase {
    var userProvider: MockService!
    var userService: UserService!

    override func setUpWithError() throws {
        userProvider = MockService(provider: "UserService", consumer: "ContractTesting-iOSApp")
        userService = UserService(baseURL: userProvider!.baseUrl)
        HTTPStubs.removeAllStubs()
    }

    func testUserService_ReturnsUserOnGET() throws {
        let expectedEmail = Faker().internet.email()
        let expectedName = Faker().name.firstName()
        let expectedAge = UInt.random(in: 20...80)
        userProvider?.given("A user with id 1 exists")
            .uponReceiving("A request for that user")
            .withRequest(method: .GET, path: "/users/1")
            .willRespondWith(status: 200,
                             headers: ["Content-Type": Matcher.term(matcher: "application/json(.*)?$", generate: "application/json")],
                             body: [
                                "name": Matcher.somethingLike(expectedName),
                                "age": Matcher.somethingLike(expectedAge),
                                "email": Matcher.term(matcher: "(.*)@(.*)", generate: expectedEmail)
            ])

        userProvider?.run(testFunction: { [self] (testComplete) in
            userService?.getUser(id: 1) { result in
                switch result {
                    case .success(let user):
                        XCTAssertEqual(user.name, expectedName)
                        XCTAssertEqual(user.age, expectedAge)
                        XCTAssertEqual(user.email, expectedEmail)
                    case .failure(let err):
                        XCTFail(err.localizedDescription)
                }
                testComplete()
            }
        })
    }

    func testUserService_Returns404WhenUserNotFound() throws {
        userProvider?.given("A user with id 1 does not exist")
            .uponReceiving("A request for that user")
            .withRequest(method: .GET, path: "/users/1")
            .willRespondWith(status: 404)

        userProvider?.run(testFunction: { [self] (testFunction) in
            userService?.getUser(id: 1) { result in
                switch result {
                    case .success: XCTFail("Did not expect a success when user cannot be found")
                    case .failure(let err):
                        XCTAssertEqual(err as? UserService.UserServiceError, .notFound)
                }
                testFunction()
            }
        })
    }

}
