//
//  UserServiceTests.swift
//  ContractTestingTests
//
//  Created by thompsty on 1/21/21.
//

import Foundation
import XCTest
import OHHTTPStubs

@testable import ContractTesting

class UserServiceTests:XCTestCase {
    
    override func setUpWithError() throws {
        HTTPStubs.removeAllStubs()
    }
    
    func testUserServiceCallsBackWithUser_OnSuccess() {
        let expectedModel = SomeModel(name: "Joe", age: 35, email: "Joe.Blow@fake.com")
        let json = try! JSONEncoder().encode(expectedModel)
        StubAPIResponse(request: .init(.get, urlString: "https://api.fake.com/users/1"),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest {
                XCTAssertEqual($0.url?.absoluteString, "https://api.fake.com/users/1")
            }
        let expectation = self.expectation(description: "Network call completed")
        
        let service = UserService()
        service.getUser { (res) in
            expectation.fulfill()
            switch res {
                case .success(let model):
                    XCTAssertEqual(try! JSONEncoder().encode(model), try! JSONEncoder().encode(expectedModel))
                case .failure(let err): XCTFail(err.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 0.3)
    }
    
    func testUserServiceCallsBackWithError_OnFailure() {
        StubAPIResponse(request: .init(.get, urlString: "https://api.fake.com/users/1"),
                        statusCode: 403,
                        result: .failure(URLError(.badServerResponse)))
            .thenVerifyRequest {
                XCTAssertEqual($0.url?.absoluteString, "https://api.fake.com/users/1")
            }
        let expectation = self.expectation(description: "Network call completed")
        
        let service = UserService()
        service.getUser { (res) in
            expectation.fulfill()
            switch res {
                case .success(_):
                    XCTFail("Should not have succeeded")
                case .failure(let err):
                    XCTAssert(err is URLError)
                    XCTAssertEqual((err as? URLError)?.code, URLError.badServerResponse)
            }
        }
        
        wait(for: [expectation], timeout: 0.3)
    }
}
