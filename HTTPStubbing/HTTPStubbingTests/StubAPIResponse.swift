//
//  StubAPIResponse.swift
//  HTTPStubbingTests
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import OHHTTPStubs

@testable import HTTPStubbing

extension URLRequest: Identifiable {
    public var id: String {
        [httpMethod, url?.absoluteString].compactMap { $0 }.joined(separator: "_")
    }
}

fileprivate extension Array {
    mutating func popLastUnlessEmpty() -> Element? {
        if count > 1 {
            return popLast()
        } else {
            return last
        }
    }
}

class StubAPIResponse {
    var results = [String: [Result<Data, Error>]]()
    var responses = [String: [HTTPURLResponse]]()
    var requests = [URLRequest]()
    var verifiers = [String: ((URLRequest) -> Void)]()

    @discardableResult init(request: URLRequest, statusCode: Int, result: Result<Data, Error>? = nil, headers: [String: String]? = nil) {
        thenRespondWith(request: request,
                        statusCode: statusCode, result: result,
                        headers: headers)
    }

    @discardableResult func thenRespondWith(request: URLRequest, statusCode: Int, result: Result<Data, Error>? = nil, headers: [String: String]? = nil) -> Self {
        guard let url = request.url else { return self }
        if let res = result {
            results[request.id, default: []].insert(res, at: 0)
        }
        responses[request.id, default: []].insert(HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "2.0", headerFields: headers)!, at: 0)
        requests.insert(request, at: 0)

        stub(condition: isAbsoluteURLString(url.absoluteString)) { [self] in
            if let verifier = verifiers[$0.id] {
                verifier($0)
            }
            let response = responses[$0.id]!.popLastUnlessEmpty()!
            let result = results[$0.id]!.popLastUnlessEmpty()!
            switch result {
            case .failure(let err): return HTTPStubsResponse(error: err)
            case .success(let data): return HTTPStubsResponse(data: data, statusCode: Int32(response.statusCode), headers: response.allHeaderFields)
            }
        }

        return self
    }

    @discardableResult func thenVerifyRequest(_ requestVerifier:@escaping ((URLRequest) -> Void)) -> Self {
        guard let req = requests.first else { return self }
        verifiers[req.id] = requestVerifier
        return self
    }
}
