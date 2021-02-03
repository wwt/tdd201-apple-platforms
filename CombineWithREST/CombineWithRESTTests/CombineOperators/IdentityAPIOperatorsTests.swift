//
//  IdentityAPIOperatorsTests.swift
//  CombineWithRESTTests
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import XCTest
import Combine

@testable import CombineWithREST

class IdentityAPIOperatorsTests: XCTestCase {
    var subscribers = Set<AnyCancellable>()

    func testRetryOnceOnUnauthorizedResponseThrowsErrorWhenNotAuthorized() {
        // swiftlint:disable:next force_try
        let data = try! JSONSerialization.data(withJSONObject: [
            "errors": [
                ["extensions": [
                    "code": "not-authorized"
                ]]
            ]
        ], options: [])

        var called = false
        let send:(data: Data, response: URLResponse) = (data: data,
                                                        response: HTTPURLResponse(url: URL(string: "https://www.google.com")!,
                                                                                  statusCode: 200,
                                                                                  httpVersion: nil,
                                                                                  headerFields: nil)!)
        Just(send)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
            .retryOnceOnUnauthorizedResponse()
            .sink { (completion) in
                called = true
                switch completion {
                    case .finished: XCTFail("Should not have finished successfully")
                    case .failure(let err):
                        XCTAssert(err is API.AuthorizationError)
                }
            } receiveValue: { _ in }
            .store(in: &subscribers)

        waitUntil(called)
        XCTAssert(called)
    }

    func testRetryOnceOnUnauthorizedResponseRetriesRequestWhenItGetsAnUnauthorizedResponse() {
        let json = """
        {
            "errors" : [
                { "extensions": { "code" : "not-authorized" } }
            ]
        }
        """.data(using: .utf8)!
        let baseURL = "https://www.google.com"
        StubAPIResponse(request: .init(.get, urlString: baseURL + "/get"), statusCode: 200, result: .success(json), headers: nil)

        let api = API.JSONPlaceHolder(baseURL: baseURL)

        var called = 0
        api.get(endpoint: "get")
            .tryMap { x in
                called += 1
                return x
            }
            .eraseToAnyPublisher()
            .retryOnceOnUnauthorizedResponse()
            .sink { (completion) in
                switch completion {
                    case .finished: XCTFail("Should not have finished successfully")
                    case .failure(let err):
                        XCTAssert(err is API.AuthorizationError)
                }
            } receiveValue: { _ in }
            .store(in: &subscribers)

        waitUntil(called > 0)
        XCTAssertEqual(called, 2)
    }

    func testRetryOnceOnUnauthorizedResponse_RetriesRequestWhenItGetsAnUnauthorizedResponse_AndSucceedsIfTheFirstCallCanBeCompletedSuccessfully() {
        let json = """
        {
            "errors" : [
                { "extensions": { "code" : "not-authorized" } }
            ]
        }
        """.data(using: .utf8)!
        let baseURL = "https://www.google.com"
        StubAPIResponse(request: .init(.get, urlString: baseURL + "/get"), statusCode: 200, result: .success(json), headers: nil)
            .thenRespondWith(request: .init(.get, urlString: baseURL + "/get"), statusCode: 200, result: .success(Data("".utf8)), headers: nil)

        let api = API.JSONPlaceHolder(baseURL: baseURL)

        var called = 0
        var finishCalled = false
        api.get(endpoint: "get")
            .tryMap { x in
                called += 1
                return x
            }
            .eraseToAnyPublisher()
            .retryOnceOnUnauthorizedResponse()
            .sink { (completion) in
                switch completion {
                    case .finished: finishCalled = true
                    case .failure:
                        XCTFail("Should not have finished with error")
                }
            } receiveValue: { _ in }
            .store(in: &subscribers)

        waitUntil(finishCalled)
        XCTAssertEqual(called, 2)
        XCTAssert(finishCalled)
    }

    func testRetryOnceOnUnauthorizedResponse_RetriesRequestWhenItGetsA401_AndSucceedsIfTheFirstCallCanBeCompletedSuccessfully() {
        let baseURL = "https://www.google.com"
        StubAPIResponse(request: .init(.get, urlString: baseURL + "/get"), statusCode: 401)
            .thenRespondWith(request: .init(.get, urlString: baseURL + "/get"), statusCode: 200, result: .success(Data("".utf8)))

        let api = API.JSONPlaceHolder(baseURL: baseURL)

        var called = 0
        var finishCalled = false
        api.get(endpoint: "get")
            .tryMap { x in
                called += 1
                return x
            }
            .eraseToAnyPublisher()
            .retryOnceOnUnauthorizedResponse()
            .sink { (completion) in
                switch completion {
                    case .finished: finishCalled = true
                    case .failure:
                        XCTFail("Should not have finished with error")
                }
            } receiveValue: { _ in }
            .store(in: &subscribers)

        waitUntil(finishCalled)
        XCTAssertEqual(called, 2)
        XCTAssert(finishCalled)
    }
}
