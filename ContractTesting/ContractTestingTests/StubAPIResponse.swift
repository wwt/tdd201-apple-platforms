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
}

public func matchesRequest(_ request: URLRequest) -> HTTPStubsTestBlock {
    return { req in req.url?.absoluteString == request.url?.absoluteString
        && req.httpMethod == request.httpMethod }
}

class StubAPIResponse {
    var results = [URLRequest: [Result<Data, Error>]]()
    var responses = [URLRequest: [HTTPURLResponse]]()
    var verifiers = [URLRequest: [((URLRequest) -> Void)]]()
    var requests = [URLRequest]()

    @discardableResult init(request: URLRequest,
                            statusCode: Int,
                            result: Result<Data, Error> = .success(Data()),
                            headers: [String: String]? = nil) {
        thenRespondWith(request: request,
                        statusCode: statusCode, result: result,
                        headers: headers)
    }

    @discardableResult func thenRespondWith(request: URLRequest,
                                            statusCode: Int,
                                            result: Result<Data, Error> = .success(Data()),
                                            headers: [String: String]? = nil) -> Self {
        guard let url = request.url else { return self }
        defer { requests.append(request) }
        results[request, default: []].insert(result, at: 0)
        responses[request, default: []].insert(HTTPURLResponse(url: url,
                                                               statusCode: statusCode,
                                                               httpVersion: "2.0",
                                                               headerFields: headers)!, at: 0)
        verifiers[request, default: []].insert({ _ in }, at: 0)

        guard !requests.contains(where: matchesRequest(request)) else { return self }

        stub(condition: matchesRequest(request)) { [self] in
            verifiers[request]?.popLastUnlessEmpty()?($0)
            let response = responses[request]!.popLastUnlessEmpty()!
            let result = results[request]!.popLastUnlessEmpty()!
            switch result {
                case .failure(let err): return HTTPStubsResponse(error: err)
                case .success(let data): return HTTPStubsResponse(data: data,
                                                                  statusCode: Int32(response.statusCode),
                                                                  headers: response.allHeaderFields)
            }
        }

        return self
    }

    @discardableResult func thenVerifyRequest(_ requestVerifier:@escaping ((URLRequest) -> Void)) -> Self {
        guard let request = requests.last else { return self }
        verifiers[request]?[0] = requestVerifier
        return self
    }
}
