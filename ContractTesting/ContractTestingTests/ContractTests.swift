//
//  ContractTestingTests.swift
//  ContractTests
//
//  Created by thompsty on 1/4/21.
//

import XCTest
import PactConsumerSwift
import Fakery
import OHHTTPStubs
@testable import ContractTesting

class ContractTests: XCTestCase {
    var userProvider:MockService!
    var userService:UserService!

    override func setUpWithError() throws {
        userProvider = MockService(provider: "UserService", consumer: "ContractTesting-iOSApp")
        userService = UserService(baseURLString: userProvider!.baseUrl)
        HTTPStubs.removeAllStubs()
    }
    
    func testUserService_ReturnsUserOnGET() {
        let expectedEmail = Faker().internet.email()
        let expectedName = Faker().name.firstName()
        let expectedAge = UInt.random(in: 20...80)
        userProvider?.given("A user with id 1 exists")
            .uponReceiving("A request for that user")
            .withRequest(method: .GET, path: "/users/1")
            .willRespondWith(status: 200, body: [
                "name" : Matcher.somethingLike(expectedName),
                "age" : Matcher.somethingLike(expectedAge),
                "email" : Matcher.term(matcher: "(.*)@(.*)", generate: expectedEmail)
            ])
        
        userProvider?.run(testFunction: { (testComplete) in
            self.userService.getUser { (result) in
                if case .success(let model) = result {
                    //Assert deserialization worked
                    XCTAssertEqual(model.name, expectedName)
                    XCTAssertEqual(model.age, expectedAge)
                    XCTAssertEqual(model.email, expectedEmail)
                } else {
                    XCTFail("Call should have succeeded")
                }
                testComplete()
            }
        })
    }
}
