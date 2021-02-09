//
//  URLRequestExtensionsTests.swift
//  CombineWithRESTTests
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import XCTest

@testable import CombineWithREST

class URLExtensionsTests: XCTestCase {
    func testAddingAcceptJSONToURLRequest() throws {
        let request = URLRequest(.get, urlString: "https://www.google.com")
        XCTAssertEqual(request.acceptingJSON().value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertNil(request.value(forHTTPHeaderField: "Accept"))
    }

    func testAddingContentTypeJSONToURLRequest() throws {
        let request = URLRequest(.get, urlString: "https://www.google.com")
        XCTAssertEqual(request.sendingJSON().value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertNil(request.value(forHTTPHeaderField: "Content-Type"))
    }

    func testAddingBearerAuthorizationJSONToURLRequest() throws {
        let request = URLRequest(.get, urlString: "https://www.google.com")
        let token = UUID().uuidString
        XCTAssertEqual(request.addingBearerAuthorization(token: token).value(forHTTPHeaderField: "Authorization"), "Bearer \(token)")
        XCTAssertNil(request.value(forHTTPHeaderField: "Authorization"))
    }

}
