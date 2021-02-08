//
//  RetryOnTests.swift
//  CombineWithRESTTests
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import XCTest
import Combine

@testable import CombineWithREST

class RetryOnTests: XCTestCase {
    var subscribers = Set<AnyCancellable>()

    func testRetryOnStartsTheChainOverIfTheErrorMatches() {
        enum Err: Error {
            case e1
            case e2
        }

        var called = 0

        let pub = TestPublisher<Int, Err> { s in
            s.receive(subscription: Subscriptions.empty)
            called += 1
            if called > 3 { s.receive(completion: .finished) }
            s.receive(completion: .failure(Err.e1))
        }

        pub.retryOn(Err.e1, retries: 1)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &subscribers)

        waitUntil(called > 0)
        XCTAssertEqual(called, 2)
    }

    func testRetryOnStartsTheChainOverTheSpecifiedNumberOfTimesIfTheErrorMatches() {
        enum Err: Error {
            case e1
            case e2
        }

        let attempts = UInt.random(in: 2...5)

        var called = 0

        let pub = TestPublisher<Int, Err> { s in
            s.receive(subscription: Subscriptions.empty)
            called += 1
            if called > attempts { s.receive(completion: .finished) }
            s.receive(completion: .failure(Err.e1))
        }

        pub.retryOn(Err.e1, retries: attempts)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &subscribers)

        waitUntil(called > 0)
        XCTAssertEqual(called, Int(attempts)+1)
    }

    func testRetryOnChainsPublishersBeforeRetrying() {
        enum Err: Error {
            case e1
            case e2
        }

        var called = 0
        var refreshCalled = 0

        // swiftlint:disable force_cast
        let refresh = TestPublisher<Int, Err> { s in
            s.receive(subscription: Subscriptions.empty)
            refreshCalled += 1
            _ = s.receive(1)
        }.eraseToAnyPublisher()
        
        TestPublisher<Int, Err> { s in
            s.receive(subscription: Subscriptions.empty)
            called += 1
            s.receive(completion: .failure(.e1))
        }.retryOn(Err.e1, retries: 1, chainedPublisher: refresh)
        .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
        .store(in: &subscribers)

        // swiftlint:enable force_cast

        waitUntil(refreshCalled > 0)
        XCTAssertEqual(called, 2)
        XCTAssertEqual(refreshCalled, 1)
    }

    func testRetryOnDoesNotRetryIfErrorDoesNotMatch() {
        enum Err: Error {
            case e1
            case e2
        }

        var called = 0

        let pub = TestPublisher<Int, Err> { s in
            s.receive(subscription: Subscriptions.empty)
            called += 1
            s.receive(completion: .failure(Err.e1))
        }
        pub.retryOn(Err.e2, retries: 1)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &subscribers)

        waitUntil(called > 0)
        XCTAssertEqual(called, 1)
    }
}
