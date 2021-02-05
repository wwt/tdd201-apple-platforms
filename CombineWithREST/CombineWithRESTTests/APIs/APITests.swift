//
//  APITests.swift
//  CombineWithRESTTests
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import XCTest
import Combine

@testable import CombineWithREST

extension API {
    struct JSONPlaceHolder: RESTAPIProtocol {
        var baseURL: String = "https://jsonplaceholder.typicode.com"
    }
}

class APITests: XCTestCase {
    
    var subscribers = Set<AnyCancellable>()
    static var swizzled = [(session: URLSession, request: URLRequest)]()

    override func setUp() {
        subscribers.forEach { $0.cancel() }
        subscribers.removeAll()
        Self.swizzled.removeAll()
    }

    func testAPIMakesAGETRequest() throws {
        let json = """
        [
            {
                userId: 1,
                id: 1,
                title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                body: "quia et suscipit suscipit recusandae consequuntur expedita et cum reprehenderit molestiae ut ut quas totam nostrum rerum est autem sunt rem eveniet architecto"
            },
        ]
        """.data(using: .utf8)!
        let jsonPlaceHolder = API.JSONPlaceHolder()
        let requestExpectation = self.expectation(description: "Request made")
        let responseExpectation = self.expectation(description: "Response recieved")
        let endpoint = "me"
        let urlString = "\(jsonPlaceHolder.baseURL)/\(endpoint)"
        StubAPIResponse(request: .init(.get, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                requestExpectation.fulfill()
                XCTAssertEqual(request.httpMethod, "GET")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                XCTAssert(request.allHTTPHeaderFields?.isEmpty == true, "Expected headers to be empty")
            }

        jsonPlaceHolder.get(endpoint: endpoint).sink { res in
            if case .failure(_) = res {
                XCTFail("You done messed up")
            }
        } receiveValue: { (data, res) in
            responseExpectation.fulfill()
            XCTAssertEqual(data, json)
        }.store(in: &subscribers)
    
        wait(for: [requestExpectation, responseExpectation], timeout: 3)
    }

    
    func testGETFailsWhenURLCannotBeConstructed() throws {
        struct FakeAPI: RESTAPIProtocol {
            var baseURL: String = ""
        }
        let responseExpectation = self.expectation(description: "Response recieved")
        
        FakeAPI().get(endpoint: "").sink { res in
            responseExpectation.fulfill()
            if case .failure(let err) = res {
                XCTAssertEqual(err as? API.URLError, .unableToCreateURL)
            }
        } receiveValue: { _ in
            XCTFail("Did not expect to get value")
        }.store(in: &subscribers)
        
        wait(for: [responseExpectation], timeout: 3)
    }

    func testAPIMakesAGETRequestWithRequestModifier() throws {
        let json = """
        [
            {
                userId: 1,
                id: 1,
                title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                body: "quia et suscipit suscipit recusandae consequuntur expedita et cum reprehenderit molestiae ut ut quas totam nostrum rerum est autem sunt rem eveniet architecto"
            },
        ]
        """.data(using: .utf8)!
        let jsonPlaceHolder = API.JSONPlaceHolder()
        let requestExpectation = self.expectation(description: "Request made")
        let responseExpectation = self.expectation(description: "Response recieved")
        let endpoint = "me"
        let urlString = "\(jsonPlaceHolder.baseURL)/\(endpoint)"
        StubAPIResponse(request: .init(.get, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                requestExpectation.fulfill()
                XCTAssertEqual(request.httpMethod, "GET")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                XCTAssertEqual(request.allHTTPHeaderFields, request.sendingJSON().allHTTPHeaderFields)
            }

        jsonPlaceHolder.get(endpoint: endpoint) { request in
            request.sendingJSON()
        }.sink { res in
            if case .failure(_) = res {
                XCTFail("You done messed up")
            }
        } receiveValue: { (data, res) in
            responseExpectation.fulfill()
            XCTAssertEqual(data, json)
        }.store(in: &subscribers)
    
        wait(for: [requestExpectation, responseExpectation], timeout: 3)
    }
    
    
    func testAPIUsesCustomURLSession() throws {
        struct FakeAPI: RESTAPIProtocol {
            var baseURL: String = "http://www.google.com"
            var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        }
        let json = """
        [
            {
                userId: 1,
                id: 1,
                title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                body: "quia et suscipit suscipit recusandae consequuntur expedita et cum reprehenderit molestiae ut ut quas totam nostrum rerum est autem sunt rem eveniet architecto"
            },
        ]
        """.data(using: .utf8)!
        let fakeAPI = FakeAPI()
        
        XCTAssertNotEqual(fakeAPI.urlSession, URLSession.shared)
        
        let endpoint = "me"
        let urlString = "\(fakeAPI.baseURL)/\(endpoint)"
        StubAPIResponse(request: .init(.get, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                XCTAssertEqual(request.httpMethod, "GET")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                XCTAssertEqual(request.allHTTPHeaderFields, request.sendingJSON().allHTTPHeaderFields)
            }
        
        _ = fakeAPI.get(endpoint: endpoint) { request in
            request.sendingJSON()
        }
        
        XCTAssertEqual(Self.swizzled.count, 1)
        XCTAssertEqual(Self.swizzled.first?.session, fakeAPI.urlSession)
    }
}


extension URLSession {
    @_dynamicReplacement(for: erasedDataTaskPublisher(for:))
    func _erasedDataTaskPublisher(for request: URLRequest) -> ErasedDataTaskPublisher {
        APITests.swizzled.append((self, request))
        return erasedDataTaskPublisher(for: request)
    }
}
