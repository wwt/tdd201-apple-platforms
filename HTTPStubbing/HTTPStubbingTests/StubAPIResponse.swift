//
//  StubAPIResponse.swift
//  HTTPStubbingTests
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import OHHTTPStubs

fileprivate extension Array {
    mutating func popLastUnlessEmpty() -> Element? {
        if count > 1 {
            return popLast()
        } else {
            return last
        }
    }

    mutating func popFirstUnlessEmpty() -> Element? {
        if count > 1 {
            defer {
                removeFirst()
            }
            return first
        } else {
            return first
        }
    }
}

class StubAPIResponse {
    var results = [String: [Result<Data, Error>]]()
    var responses = [String: [HTTPURLResponse]]()
    var verifiers = [String: [((URLRequest) -> Void)]]()
    var requests = [URLRequest]()
    var stubs = [String: [HTTPStubsResponseBlock]]()

    @discardableResult init(request: URLRequest, statusCode: Int, result: Result<Data, Error>? = nil, headers: [String: String]? = nil) {
        thenRespondWith(request: request,
                        statusCode: statusCode, result: result,
                        headers: headers)
    }

    @discardableResult func thenRespondWith(request: URLRequest, statusCode: Int, result: Result<Data, Error>? = nil, headers: [String: String]? = nil) -> Self {
        guard let url = request.url else { return self }
        if let res = result {
            results[url.absoluteString, default: []].insert(res, at: 0)
        }
        responses[url.absoluteString, default: []].insert(HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "2.0", headerFields: headers)!, at: 0)
        verifiers[url.absoluteString, default: []].insert({ _ in }, at: 0)
        requests.append(request)

        stubs[url.absoluteString, default: []].append { [self] in
            verifiers[url.absoluteString]?.popLastUnlessEmpty()?($0)
            let response = responses[url.absoluteString]!.popLastUnlessEmpty()!
            if let result = results[url.absoluteString]?.popLastUnlessEmpty() {
                switch result {
                    case .failure(let err): return HTTPStubsResponse(error: err)
                    case .success(let data): return HTTPStubsResponse(data: data, statusCode: Int32(response.statusCode), headers: response.allHeaderFields)
                }
            }
            return HTTPStubsResponse(data: Data(), statusCode: Int32(response.statusCode), headers: response.allHeaderFields)
        }

        guard var allStubForURL = stubs[url.absoluteString],
              allStubForURL.count == 1 else { return self }

        stub(condition: isAbsoluteURLString(url.absoluteString)) {
            return allStubForURL.popFirstUnlessEmpty()!($0)
        }

        return self
    }

    @discardableResult func thenVerifyRequest(_ requestVerifier:@escaping ((URLRequest) -> Void)) -> Self {
        guard let url = requests.last?.url else { return self }
        verifiers[url.absoluteString]?[0] = requestVerifier
        return self
    }
}
