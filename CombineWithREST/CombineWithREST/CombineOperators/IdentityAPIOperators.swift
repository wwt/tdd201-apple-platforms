//
//  IdentityAPIOperators.swift
//  CombineWithREST
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import Combine

extension URLSession.ErasedDataTaskPublisher {
    func retryOnceOnUnauthorizedResponse<P: Publisher>(chainedRequest: P) -> Self where P.Output == Output, P.Failure == Failure {
        tryMap { args -> URLSession.ErasedDataTaskPublisher.Output in
            if let res = args.response as? HTTPURLResponse, res.statusCode == 401 {
                throw API.AuthorizationError.unauthorized
            }
            return args
        }.retryOn(API.AuthorizationError.unauthorized,
                  retries: 1, chainedPublisher: chainedRequest)
        .eraseToAnyPublisher()
    }
}
