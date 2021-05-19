//
//  RetryOn.swift
//  CombineWithREST
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import Combine

extension Publisher {
    /// Attempts to recreate a failed subscription with the upstream publisher using a specified number of attempts to establish the connection.
    ///
    /// After exceeding the specified number of retries, the publisher passes the failure to the downstream receiver.
    /// - Parameter error: An equatable error that should trigger the retry
    /// - Parameter retries: The number of times to attempt to recreate the subscription.
    /// - Parameter chainedRequest: An optional publisher of the same type, to chain before the retry
    /// - Returns: A publisher that attempts to recreate its subscription to a failed upstream publisher.
    // swiftlint:disable:next line_length
    func retryOn<E: Error & Equatable, C: Publisher>(_ error: E, retries: UInt, chainedPublisher: C) -> AnyPublisher<Output, Failure> where C.Output == Output, C.Failure == Failure {
        self.catch { error -> AnyPublisher<Output, Failure> in
            guard retries > 0 else {
                return Fail<Output, Failure>(error: error).eraseToAnyPublisher()
            }

            return chainedPublisher
                .flatMap { _ in self }
                .retry(Int(retries) - 1)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }

    /// Attempts to recreate a failed subscription with the upstream publisher using a specified number of attempts to establish the connection.
    ///
    /// After exceeding the specified number of retries, the publisher passes the failure to the downstream receiver.
    /// - Parameter error: An equatable error that should trigger the retry
    /// - Parameter retries: The number of times to attempt to recreate the subscription.
    /// - Returns: A publisher that attempts to recreate its subscription to a failed upstream publisher.
    func retryOn<E: Error & Equatable>(_ error: E, retries: UInt) -> AnyPublisher<Output, Failure> {
        self.catch { error -> AnyPublisher<Output, Failure> in
            guard retries > 0 else {
                return Fail<Output, Failure>(error: error).eraseToAnyPublisher()
            }
            return self
                .retry(Int(retries) - 1)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
