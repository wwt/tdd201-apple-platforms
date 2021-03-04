//
//  ContractTests.swift
//  SwiftUIExampleTests
//
//  Created by thompsty on 3/4/21.
//

// swiftlint:disable function_body_length

import Foundation
import XCTest
import PactConsumerSwift
import Fakery
import Combine

@testable import SwiftUIExample

class ContractTests: XCTestCase {
    var hikesServiceProvider: MockService!
    var ongoingCalls = Set<AnyCancellable>()

    override func setUpWithError() throws {
        hikesServiceProvider = MockService(provider: "HikesService", consumer: "SwiftUIExample-iOSApp")
        ongoingCalls.removeAll()
    }

    func testHikesServiceCanGetAllHikes() throws {
        let service = API.HikesService(baseURL: hikesServiceProvider.baseUrl)
        let elevation = Double.random(in: 300.0..<320.3532820173541)
        let pace = Double.random(in: 390.0..<400.08716481908732)
        let heartRate = Double.random(in: 110.0..<120.72304232462609)
        let expectedHike = Hike(id: Int.random(in: 1000..<10000),
                                name: Faker().address.city(),
                                distance: Double.random(in: 1.0..<10.0),
                                difficulty: Int.random(in: 1..<10),
                                observations: [
                                    Hike.Observation(distanceFromStart: Double.random(in: 1.0..<10.0),
                                                     elevation: elevation..<elevation,
                                                     pace: pace..<pace,
                                                     heartRate: heartRate..<heartRate)
                                ])
        hikesServiceProvider.given("Multiple hikes exist")
            .uponReceiving("A request for all hikes")
            .withRequest(method: .GET,
                         path: "/hikes",
                         headers: [
                            "Content-Type": Matcher.term(matcher: "application/json(.*)?$", generate: "application/json"),
                            "Accept": Matcher.term(matcher: "application/json(.*)?$", generate: "application/json")
                         ])
            .willRespondWith(status: 200,
                             headers: [
                                "Content-Type": Matcher.term(matcher: "application/json(.*)?$", generate: "application/json")
                             ],
                             body: Matcher.eachLike([
                                "name": Matcher.somethingLike(expectedHike.name),
                                "id": Matcher.somethingLike(expectedHike.id),
                                "distance": Matcher.somethingLike(expectedHike.distance),
                                "difficulty": Matcher.somethingLike(expectedHike.difficulty),
                                "observations": Matcher.eachLike([
                                    "elevation": Matcher.eachLike(Matcher.somethingLike(expectedHike.observations.first!.elevation.lowerBound), min: 2),
                                    "pace": Matcher.eachLike(Matcher.somethingLike(expectedHike.observations.first!.pace.lowerBound), min: 2),
                                    "heartRate": Matcher.eachLike(Matcher.somethingLike(expectedHike.observations.first!.heartRate.lowerBound), min: 2),
                                    "distanceFromStart": Matcher.somethingLike(expectedHike.observations.first!.distanceFromStart)
                                ])
                             ]))

        hikesServiceProvider.run { [self] (testComplete) in
            service.fetchHikes.sink { result in
                switch result {
                    case .success(let hikes):
                        XCTAssertEqual(hikes.count, 1)
                        XCTAssertEqual(hikes.first, expectedHike)
                    case .failure(let err):
                        if case .apiBorked(let error) = err {
                            XCTFail(error.localizedDescription)
                        } else {
                            XCTFail(err.localizedDescription)
                        }
                }
                testComplete()
            }.store(in: &ongoingCalls)
        }
    }
}
