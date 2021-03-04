//
//  URLSessionExtensions.swift
//  SwiftUIExample
//
//  Created by thompsty on 3/4/21.
//

import Foundation
import Combine

extension URLSession {
    typealias ErasedDataTaskPublisher = AnyPublisher<(data: Data, response: URLResponse), Error>

    func erasedDataTaskPublisher(
        for request: URLRequest
    ) -> ErasedDataTaskPublisher {
        dataTaskPublisher(for: request)
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
