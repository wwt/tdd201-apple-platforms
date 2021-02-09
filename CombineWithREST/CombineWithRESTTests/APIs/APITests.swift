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
    
    func testGETRecalculatesRequestModifierWhenChainIsRestarted() throws {
        let responseExpectation = self.expectation(description: "Response recieved")
        var requestModifierCalled = 0
        
        API.JSONPlaceHolder()
            .get(endpoint: "") {
                requestModifierCalled += 1
                return $0
            }
            .tryMap { _ in throw API.URLError.unableToCreateURL }
            .retry(1)
            .sink { res in
                responseExpectation.fulfill()
                if case .failure(let err) = res {
                    XCTAssertEqual(err as? API.URLError, .unableToCreateURL)
                }
            } receiveValue: { _ in
                XCTFail("Did not expect to get value")
            }.store(in: &subscribers)
        
        wait(for: [responseExpectation], timeout: 3)
        XCTAssertEqual(requestModifierCalled, 2)
    }
    
    func testAPIMakesAPUTRequestWithNoBody() throws {
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
        StubAPIResponse(request: .init(.put, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                requestExpectation.fulfill()
                XCTAssertEqual(request.httpMethod, "PUT")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                XCTAssert(request.allHTTPHeaderFields?.isEmpty == true, "Expected headers to be empty")
                XCTAssertNil(request.bodySteamAsData())
            }

        jsonPlaceHolder.put(endpoint: endpoint).sink { res in
            if case .failure(_) = res {
                XCTFail("You done messed up")
            }
        } receiveValue: { (data, res) in
            responseExpectation.fulfill()
            XCTAssertEqual(data, json)
        }.store(in: &subscribers)
    
        wait(for: [requestExpectation, responseExpectation], timeout: 3)
    }
    
    func testAPIMakesAPUTRequestWithABody() throws {
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
        let body = UUID().uuidString.data(using: .utf8)
        StubAPIResponse(request: .init(.put, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                requestExpectation.fulfill()
                XCTAssertEqual(request.httpMethod, "PUT")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                
                XCTAssertEqual(request.allHTTPHeaderFields?["Content-Length"], "\(body!.count)")
                XCTAssertEqual(request.bodySteamAsData(), body)
            }

        jsonPlaceHolder.put(endpoint: endpoint, body: body).sink { res in
            if case .failure(_) = res {
                XCTFail("You done messed up")
            }
        } receiveValue: { (data, res) in
            responseExpectation.fulfill()
            XCTAssertEqual(data, json)
        }.store(in: &subscribers)

        wait(for: [requestExpectation, responseExpectation], timeout: 3)
    }


    func testPUTFailsWhenURLCannotBeConstructed() throws {
        struct FakeAPI: RESTAPIProtocol {
            var baseURL: String = ""
        }
        let responseExpectation = self.expectation(description: "Response recieved")

        FakeAPI().put(endpoint: "").sink { res in
            responseExpectation.fulfill()
            if case .failure(let err) = res {
                XCTAssertEqual(err as? API.URLError, .unableToCreateURL)
            }
        } receiveValue: { _ in
            XCTFail("Did not expect to get value")
        }.store(in: &subscribers)

        wait(for: [responseExpectation], timeout: 3)
    }

    func testAPIMakesAPUTRequestWithRequestModifier() throws {
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
        let body = UUID().uuidString.data(using: .utf8)
        StubAPIResponse(request: .init(.put, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                requestExpectation.fulfill()
                XCTAssertEqual(request.httpMethod, "PUT")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                XCTAssertEqual(request.allHTTPHeaderFields, request.sendingJSON().allHTTPHeaderFields)
                XCTAssertEqual(request.bodySteamAsData(), body)
            }

        jsonPlaceHolder.put(endpoint: endpoint, body: body) { request in
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
    
    func testPUTRecalculatesRequestModifierWhenChainIsRestarted() throws {
        let responseExpectation = self.expectation(description: "Response recieved")
        var requestModifierCalled = 0
        
        API.JSONPlaceHolder()
            .put(endpoint: "") {
                requestModifierCalled += 1
                return $0
            }
            .tryMap { _ in throw API.URLError.unableToCreateURL }
            .retry(1)
            .sink { res in
                responseExpectation.fulfill()
                if case .failure(let err) = res {
                    XCTAssertEqual(err as? API.URLError, .unableToCreateURL)
                }
            } receiveValue: { _ in
                XCTFail("Did not expect to get value")
            }.store(in: &subscribers)
        
        wait(for: [responseExpectation], timeout: 3)
        XCTAssertEqual(requestModifierCalled, 2)
    }
    
    func testAPIMakesAPOSTRequestWithNoBody() throws {
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
        StubAPIResponse(request: .init(.post, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                requestExpectation.fulfill()
                XCTAssertEqual(request.httpMethod, "POST")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                XCTAssert(request.allHTTPHeaderFields?.isEmpty == true, "Expected headers to be empty")
                XCTAssertNil(request.bodySteamAsData())
            }

        jsonPlaceHolder.post(endpoint: endpoint).sink { res in
            if case .failure(_) = res {
                XCTFail("You done messed up")
            }
        } receiveValue: { (data, res) in
            responseExpectation.fulfill()
            XCTAssertEqual(data, json)
        }.store(in: &subscribers)
    
        wait(for: [requestExpectation, responseExpectation], timeout: 3)
    }
    
    func testAPIMakesAPOSTRequestWithABody() throws {
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
        let body = UUID().uuidString.data(using: .utf8)
        StubAPIResponse(request: .init(.post, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                requestExpectation.fulfill()
                XCTAssertEqual(request.httpMethod, "POST")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                
                XCTAssertEqual(request.allHTTPHeaderFields?["Content-Length"], "\(body!.count)")
                XCTAssertEqual(request.bodySteamAsData(), body)
            }

        jsonPlaceHolder.post(endpoint: endpoint, body: body).sink { res in
            if case .failure(_) = res {
                XCTFail("You done messed up")
            }
        } receiveValue: { (data, res) in
            responseExpectation.fulfill()
            XCTAssertEqual(data, json)
        }.store(in: &subscribers)

        wait(for: [requestExpectation, responseExpectation], timeout: 3)
    }


    func testPOSTFailsWhenURLCannotBeConstructed() throws {
        struct FakeAPI: RESTAPIProtocol {
            var baseURL: String = ""
        }
        let responseExpectation = self.expectation(description: "Response recieved")

        FakeAPI().post(endpoint: "").sink { res in
            responseExpectation.fulfill()
            if case .failure(let err) = res {
                XCTAssertEqual(err as? API.URLError, .unableToCreateURL)
            }
        } receiveValue: { _ in
            XCTFail("Did not expect to get value")
        }.store(in: &subscribers)

        wait(for: [responseExpectation], timeout: 3)
    }

    func testAPIMakesAPOSTRequestWithRequestModifier() throws {
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
        let body = UUID().uuidString.data(using: .utf8)
        StubAPIResponse(request: .init(.post, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                requestExpectation.fulfill()
                XCTAssertEqual(request.httpMethod, "POST")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                XCTAssertEqual(request.allHTTPHeaderFields, request.sendingJSON().allHTTPHeaderFields)
                XCTAssertEqual(request.bodySteamAsData(), body)
            }

        jsonPlaceHolder.post(endpoint: endpoint, body: body) { request in
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
    
    func testPOSTRecalculatesRequestModifierWhenChainIsRestarted() throws {
        let responseExpectation = self.expectation(description: "Response recieved")
        var requestModifierCalled = 0
        
        API.JSONPlaceHolder()
            .post(endpoint: "") {
                requestModifierCalled += 1
                return $0
            }
            .tryMap { _ in throw API.URLError.unableToCreateURL }
            .retry(1)
            .sink { res in
                responseExpectation.fulfill()
                if case .failure(let err) = res {
                    XCTAssertEqual(err as? API.URLError, .unableToCreateURL)
                }
            } receiveValue: { _ in
                XCTFail("Did not expect to get value")
            }.store(in: &subscribers)
        
        wait(for: [responseExpectation], timeout: 3)
        XCTAssertEqual(requestModifierCalled, 2)
    }
    
    func testAPIMakesAPATCHRequestWithNoBody() throws {
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
        StubAPIResponse(request: .init(.patch, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                requestExpectation.fulfill()
                XCTAssertEqual(request.httpMethod, "PATCH")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                XCTAssert(request.allHTTPHeaderFields?.isEmpty == true, "Expected headers to be empty")
                XCTAssertNil(request.bodySteamAsData())
            }

        jsonPlaceHolder.patch(endpoint: endpoint).sink { res in
            if case .failure(_) = res {
                XCTFail("You done messed up")
            }
        } receiveValue: { (data, res) in
            responseExpectation.fulfill()
            XCTAssertEqual(data, json)
        }.store(in: &subscribers)
    
        wait(for: [requestExpectation, responseExpectation], timeout: 3)
    }
    
    func testAPIMakesAPATCHRequestWithABody() throws {
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
        let body = UUID().uuidString.data(using: .utf8)
        StubAPIResponse(request: .init(.patch, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                requestExpectation.fulfill()
                XCTAssertEqual(request.httpMethod, "PATCH")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                
                XCTAssertEqual(request.allHTTPHeaderFields?["Content-Length"], "\(body!.count)")
                XCTAssertEqual(request.bodySteamAsData(), body)
            }

        jsonPlaceHolder.patch(endpoint: endpoint, body: body).sink { res in
            if case .failure(_) = res {
                XCTFail("You done messed up")
            }
        } receiveValue: { (data, res) in
            responseExpectation.fulfill()
            XCTAssertEqual(data, json)
        }.store(in: &subscribers)

        wait(for: [requestExpectation, responseExpectation], timeout: 3)
    }


    func testPATCHFailsWhenURLCannotBeConstructed() throws {
        struct FakeAPI: RESTAPIProtocol {
            var baseURL: String = ""
        }
        let responseExpectation = self.expectation(description: "Response recieved")

        FakeAPI().patch(endpoint: "").sink { res in
            responseExpectation.fulfill()
            if case .failure(let err) = res {
                XCTAssertEqual(err as? API.URLError, .unableToCreateURL)
            }
        } receiveValue: { _ in
            XCTFail("Did not expect to get value")
        }.store(in: &subscribers)

        wait(for: [responseExpectation], timeout: 3)
    }

    func testAPIMakesAPATCHRequestWithRequestModifier() throws {
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
        let body = UUID().uuidString.data(using: .utf8)
        StubAPIResponse(request: .init(.patch, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                requestExpectation.fulfill()
                XCTAssertEqual(request.httpMethod, "PATCH")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                XCTAssertEqual(request.allHTTPHeaderFields, request.sendingJSON().allHTTPHeaderFields)
                XCTAssertEqual(request.bodySteamAsData(), body)
            }

        jsonPlaceHolder.patch(endpoint: endpoint, body: body) { request in
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
    
    func testPATCHRecalculatesRequestModifierWhenChainIsRestarted() throws {
        let responseExpectation = self.expectation(description: "Response recieved")
        var requestModifierCalled = 0
        
        API.JSONPlaceHolder()
            .patch(endpoint: "") {
                requestModifierCalled += 1
                return $0
            }
            .tryMap { _ in throw API.URLError.unableToCreateURL }
            .retry(1)
            .sink { res in
                responseExpectation.fulfill()
                if case .failure(let err) = res {
                    XCTAssertEqual(err as? API.URLError, .unableToCreateURL)
                }
            } receiveValue: { _ in
                XCTFail("Did not expect to get value")
            }.store(in: &subscribers)
        
        wait(for: [responseExpectation], timeout: 3)
        XCTAssertEqual(requestModifierCalled, 2)
    }
    
    func testAPIMakesADELETERequest() throws {
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
        StubAPIResponse(request: .init(.delete, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                requestExpectation.fulfill()
                XCTAssertEqual(request.httpMethod, "DELETE")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                XCTAssert(request.allHTTPHeaderFields?.isEmpty == true, "Expected headers to be empty")
            }

        jsonPlaceHolder.delete(endpoint: endpoint).sink { res in
            if case .failure(_) = res {
                XCTFail("You done messed up")
            }
        } receiveValue: { (data, res) in
            responseExpectation.fulfill()
            XCTAssertEqual(data, json)
        }.store(in: &subscribers)
    
        wait(for: [requestExpectation, responseExpectation], timeout: 3)
    }

    
    func testDELETEFailsWhenURLCannotBeConstructed() throws {
        struct FakeAPI: RESTAPIProtocol {
            var baseURL: String = ""
        }
        let responseExpectation = self.expectation(description: "Response recieved")
        
        FakeAPI().delete(endpoint: "").sink { res in
            responseExpectation.fulfill()
            if case .failure(let err) = res {
                XCTAssertEqual(err as? API.URLError, .unableToCreateURL)
            }
        } receiveValue: { _ in
            XCTFail("Did not expect to get value")
        }.store(in: &subscribers)
        
        wait(for: [responseExpectation], timeout: 3)
    }

    func testAPIMakesADELETERequestWithRequestModifier() throws {
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
        StubAPIResponse(request: .init(.delete, urlString: urlString),
                        statusCode: 200,
                        result: .success(json))
            .thenVerifyRequest { (request) in
                requestExpectation.fulfill()
                XCTAssertEqual(request.httpMethod, "DELETE")
                XCTAssertEqual(request.url?.absoluteString, urlString)
                XCTAssertEqual(request.allHTTPHeaderFields, request.sendingJSON().allHTTPHeaderFields)
            }

        jsonPlaceHolder.delete(endpoint: endpoint) { request in
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

    func testDELETERecalculatesRequestModifierWhenChainIsRestarted() throws {
        let responseExpectation = self.expectation(description: "Response recieved")
        var requestModifierCalled = 0
        
        API.JSONPlaceHolder()
            .delete(endpoint: "") {
                requestModifierCalled += 1
                return $0
            }
            .tryMap { _ in throw API.URLError.unableToCreateURL }
            .retry(1)
            .sink { res in
                responseExpectation.fulfill()
                if case .failure(let err) = res {
                    XCTAssertEqual(err as? API.URLError, .unableToCreateURL)
                }
            } receiveValue: { _ in
                XCTFail("Did not expect to get value")
            }.store(in: &subscribers)
        
        wait(for: [responseExpectation], timeout: 3)
        XCTAssertEqual(requestModifierCalled, 2)
    }
    
    func testAPIUsesCustomURLSession() throws {
        struct FakeAPI: RESTAPIProtocol {
            var baseURL: String = "http://www.google.com"
            var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        }
        let fakeAPI = FakeAPI()
        
        XCTAssertNotEqual(fakeAPI.urlSession, URLSession.shared)
        
        let endpoint = "me"
        let urlString = "\(fakeAPI.baseURL)/\(endpoint)"
        StubAPIResponse(request: .init(.get, urlString: urlString),
                        statusCode: 200)
            .thenRespondWith(request: .init(.put, urlString: urlString),
                             statusCode: 200)
            .thenRespondWith(request: .init(.post, urlString: urlString),
                             statusCode: 200)
            .thenRespondWith(request: .init(.patch, urlString: urlString),
                             statusCode: 200)
            .thenRespondWith(request: .init(.delete, urlString: urlString),
                             statusCode: 200)

        fakeAPI.get(endpoint: endpoint) { request in
            request.sendingJSON()
        }
        .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
        .store(in: &subscribers)
        
        XCTAssertEqual(Self.swizzled.count, 1)
        XCTAssertEqual(Self.swizzled.first?.session, fakeAPI.urlSession)
        
        
        Self.swizzled.removeAll()
        
        fakeAPI.put(endpoint: endpoint) { request in
            request.sendingJSON()
        }
        .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
        .store(in: &subscribers)

        XCTAssertEqual(Self.swizzled.count, 1)
        XCTAssertEqual(Self.swizzled.first?.session, fakeAPI.urlSession)
        
        Self.swizzled.removeAll()
        
        fakeAPI.post(endpoint: endpoint) { request in
            request.sendingJSON()
        }
        .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
        .store(in: &subscribers)

        XCTAssertEqual(Self.swizzled.count, 1)
        XCTAssertEqual(Self.swizzled.first?.session, fakeAPI.urlSession)
        
        Self.swizzled.removeAll()
        
        fakeAPI.patch(endpoint: endpoint) { request in
            request.sendingJSON()
        }
        .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
        .store(in: &subscribers)

        XCTAssertEqual(Self.swizzled.count, 1)
        XCTAssertEqual(Self.swizzled.first?.session, fakeAPI.urlSession)
        
        Self.swizzled.removeAll()
        
        fakeAPI.delete(endpoint: endpoint) { request in
            request.sendingJSON()
        }
        .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
        .store(in: &subscribers)

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
