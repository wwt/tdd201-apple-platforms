//
//  HTTPStubbingTests.swift
//  HTTPStubbingTests
//
//  Created by thompsty on 1/4/21.
//

import XCTest
@testable import HTTPStubbing

extension SomeModel: Equatable {
    public static func == (lhs:SomeModel, rhs:SomeModel) -> Bool {
        guard let lhsSerialized = try? JSONEncoder().encode(lhs),
              let rhsSerialized = try? JSONEncoder().encode(rhs) else {
            return false
        }
        
        return lhsSerialized == rhsSerialized
    }
}

class HTTPStubbingTests: XCTestCase {

    func testMakingANetworkRequestDeserializesModels() {
        let expectedModel = SomeModel(name: "Joe", age: 35, email: "Joe.Blow@fake.com")
        let json = try! JSONEncoder().encode(expectedModel)
        StubAPIResponse(request: .init(.get, urlString: "https://api.fake.com/users/me"),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest {
                XCTAssertEqual($0.url?.absoluteString, "https://api.fake.com/users/me")
            }
        
        let controller = ViewController()
        controller.makeNetworkRequest()
        
        waitUntil(controller.model != nil)
        XCTAssertEqual(controller.model, expectedModel)
    }

}
