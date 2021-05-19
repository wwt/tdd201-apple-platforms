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
        var called: UInt = 0

        let pub = TestPublisher<Int, Err> { s in
            s.receive(subscription: Subscriptions.empty)
            called += 1
            if called > attempts { s.receive(completion: .finished) }
            s.receive(completion: .failure(Err.e1))
        }

        pub.retryOn(Err.e1, retries: attempts)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &subscribers)

        waitUntil(called > attempts)
        XCTAssertEqual(called, attempts + 1)
    }

    func testRetryOnChainsPublishersBeforeRetrying() {
        enum Err: Error {
            case e1
            case e2
        }
        var called = 0
        let refresh = Just(1)
            .setFailureType(to: Err.self)
            .map { i -> Int in
                called += 1
                return i
            }
            .eraseToAnyPublisher()

        Just(1)
            .setFailureType(to: Err.self)
            .tryMap { _ -> Int in
                throw Err.e1
            }.mapError { $0 as! Err } // swiftlint:disable:this force_cast
            .retryOn(Err.e1, retries: 1, chainedPublisher: refresh)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &subscribers)

        waitUntil(called > 0)
        XCTAssertEqual(called, 1)
    }

    func testRetryOnChainsPublishersEachTimeWhileRetrying() {
        enum Err: Error {
            case e1
            case e2
        }
        let attempts = UInt.random(in: 2...5)
        var mainCalled: UInt = 0
        var refreshCalled: UInt = 0
        let refresh = [1].publisher
            .setFailureType(to: Err.self)
            .tryMap { i -> Int in
                refreshCalled += 1
                return i
            }.mapError { $0 as! Err } // swiftlint:disable:this force_cast
            .eraseToAnyPublisher()

        [1].publisher
            .setFailureType(to: Err.self)
            .tryMap {
                mainCalled += 1
                if mainCalled < attempts { throw Err.e1 }
                return $0
            }.mapError { $0 as! Err } // swiftlint:disable:this force_cast
            .retryOn(Err.e1, retries: attempts, chainedPublisher: refresh)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &subscribers)

        waitUntil(mainCalled >= attempts)
        XCTAssertEqual(mainCalled, attempts)
        XCTAssertEqual(refreshCalled, attempts - 1)
    }

    func testRetryOnDoesNotRetryIfErrorDoesNotMatch() {
        enum Err: Error {
            case e1
            case e2
        }
        var called = 0

        Just(1)
            .setFailureType(to: Err.self)
            .tryMap { _ -> Int in
                called += 1
                throw Err.e1
            }.mapError { $0 as! Err } // swiftlint:disable:this force_cast
            .retryOn(Err.e2, retries: 1)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &subscribers)

        waitUntil(called > 0)
        XCTAssertEqual(called, 1)
    }
}
