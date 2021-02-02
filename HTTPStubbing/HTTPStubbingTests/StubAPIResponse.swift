//
//  StubAPIResponse.swift
//  HTTPStubbingTests
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import OHHTTPStubs

@testable import HTTPStubbing

fileprivate extension Array {
    mutating func popLastUnlessEmpty() -> Element? {
        if (count > 1) {
            return popLast()
        } else {
            return last
        }
    }
}

extension Result where Success: Hashable {
    var hashValue:Int {
        switch self {
            case .success(let hashable): return hashable.hashValue
            case .failure(let err): return err.localizedDescription.hashValue
        }
    }
}

class StubAPIResponse {
    var results = [String: [Result<Data, Error>]]()
    var responses = [String: [HTTPURLResponse]]()
    var verifiers = [String: ((URLRequest) -> Void)]()
    var ids = [String]()
    var stubClosures = [HTTPStubsResponseBlock]()
    
    @discardableResult init(request:URLRequest, statusCode:Int, result:Result<Data, Error>? = nil, headers:[String : String]? = nil) {
        thenRespondWith(request: request,
                        statusCode: statusCode, result: result,
                        headers: headers)
    }
    
    @discardableResult func thenRespondWith(request:URLRequest, statusCode:Int, result:Result<Data, Error>? = nil, headers:[String : String]? = nil) -> Self {
        guard let url = request.url else { return self }
        let id = "\(request.hashValue)|\(statusCode)|\(String(describing: result?.hashValue))|\(String(describing: headers?.hashValue))"
        ids.append(id)
        if let res = result {
            results[id, default: []].insert(res, at: 0)
        }
        responses[id, default: []].insert(HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "2.0", headerFields: headers)!, at: 0)
        
        stubClosures.append { [self] in
            if let verifier = verifiers[id] {
                verifier($0)
            }
            let response = responses[id]!.popLastUnlessEmpty()!
            if let result = results[id]?.popLastUnlessEmpty() {
                switch result {
                case .failure(let err): return HTTPStubsResponse(error: err)
                case .success(let data): return HTTPStubsResponse(data: data, statusCode: Int32(response.statusCode), headers: response.allHeaderFields)
                }
            }
            return HTTPStubsResponse(data: Data(), statusCode: Int32(response.statusCode), headers: response.allHeaderFields)
        }
        
        stub(condition: isAbsoluteURLString(url.absoluteString)) { [self] in
            defer {
                if (stubClosures.count > 1) {
                    stubClosures.removeFirst()
                }
            }
            return stubClosures.first!($0)
        }

        return self
    }
    
    @discardableResult func thenVerifyRequest(_ requestVerifier:@escaping ((URLRequest) -> Void)) -> Self {
        guard let id = ids.last else { return self }
        verifiers[id] = requestVerifier
        return self
    }
}
