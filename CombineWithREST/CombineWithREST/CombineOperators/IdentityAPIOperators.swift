//
//  IdentityAPIOperators.swift
//  CombineWithREST
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import Combine

extension URLSession.ErasedDataTaskPublisher {
    func retryOnceOnUnauthorizedResponse(chainedRequest: AnyPublisher<Output, Error>? = nil) -> AnyPublisher<Output, Error> {
        tryMap { data, response -> URLSession.ErasedDataTaskPublisher.Output in
            if let res = response as? HTTPURLResponse,
               res.statusCode == 401 {
                throw API.AuthorizationError.unauthorized
            } else if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let errors = json["errors"] as? [[String: Any]] {
                if (errors.contains(where: { ($0["extensions"] as? [String: Any])?["code"] as? String == "not-authorized" })) {
                    throw API.AuthorizationError.unauthorized
                }
            }
            return (data:data, response:response)
        }
        .retryOn(API.AuthorizationError.unauthorized, retries: 1, chainedPublisher: chainedRequest)
        .eraseToAnyPublisher()
    }

}
