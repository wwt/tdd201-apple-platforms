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

    func testHikesServiceCanGetAllLandmarks() throws {
        let service = API.HikesService(baseURL: hikesServiceProvider.baseUrl)
        let expectedLandmark = Landmark.createForTests(id: Int.random(in: 1000..<10000),
                                                       name: Faker().address.city(),
                                                       park: Faker().address.city(),
                                                       state: Faker().address.state(),
                                                       description: Faker().lorem.paragraphs(),
                                                       isFavorite: Bool.random(),
                                                       isFeatured: Bool.random(),
                                                       category: Landmark.Category.allCases.randomElement()!,
                                                       coordinates: Landmark.Coordinates(latitude: Faker().address.latitude(),
                                                                                         longitude: Faker().address.longitude()))

        hikesServiceProvider.given("Multiple landmarks exist")
            .uponReceiving("A request for all landmarks")
            .withRequest(method: .GET,
                         path: "/landmarks",
                         headers: [
                            "Content-Type": Matcher.term(matcher: "application/json(.*)?$", generate: "application/json"),
                            "Accept": Matcher.term(matcher: "application/json(.*)?$", generate: "application/json")
                         ])
            .willRespondWith(status: 200,
                             headers: [
                                "Content-Type": Matcher.term(matcher: "application/json(.*)?$", generate: "application/json")
                             ],
                             body: Matcher.eachLike([
                                "name": Matcher.somethingLike(expectedLandmark.name),
                                "category": Matcher.term(matcher: Landmark.Category.allCases.map { $0.rawValue }.joined(separator: "|"),
                                                         generate: expectedLandmark.category.rawValue),
                                "city": Matcher.somethingLike(Faker().address.city()),
                                "state": Matcher.somethingLike(expectedLandmark.state),
                                "id": Matcher.somethingLike(expectedLandmark.id),
                                "isFeatured": Matcher.somethingLike(expectedLandmark.isFeatured),
                                "isFavorite": Matcher.somethingLike(expectedLandmark.isFavorite),
                                "park": Matcher.somethingLike(expectedLandmark.park),
                                "coordinates": [
                                    "longitude": Matcher.somethingLike(expectedLandmark.locationCoordinate.longitude),
                                    "latitude": Matcher.somethingLike(expectedLandmark.locationCoordinate.latitude)
                                ],
                                "description": Matcher.somethingLike(expectedLandmark.description),
                                "imageName": Matcher.somethingLike("turtlerock")
                             ]))

        hikesServiceProvider.run { [self] (testComplete) in
            service.fetchLandmarks.sink { result in
                switch result {
                    case .success(let landmarks):
                        XCTAssertEqual(landmarks.count, 1)
                        XCTAssertEqual(landmarks.first, expectedLandmark)
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

    func testLandmarkCanBeFavorited() throws {
        let service = API.HikesService(baseURL: hikesServiceProvider.baseUrl)
        let expectedLandmark = Landmark.createForTests(id: 1,
                                                       name: Faker().address.city(),
                                                       park: Faker().address.city(),
                                                       state: Faker().address.state(),
                                                       description: Faker().lorem.paragraphs(),
                                                       isFavorite: true,
                                                       isFeatured: Bool.random(),
                                                       category: Landmark.Category.allCases.randomElement()!,
                                                       coordinates: Landmark.Coordinates(latitude: Faker().address.latitude(),
                                                                                         longitude: Faker().address.longitude()))

        hikesServiceProvider.given("A landmark that is NOT favorited with id 1")
            .uponReceiving("A request to favorite a landmark")
            .withRequest(method: .PUT, path: "/landmarks/1/favorite",
                         headers: [
                            "Content-Type": Matcher.term(matcher: "application/json(.*)?$", generate: "application/json"),
                            "Accept": Matcher.term(matcher: "application/json(.*)?$", generate: "application/json")
                         ],
                         body: [
                            "isFavorite": true
                         ])
            .willRespondWith(status: 200,
                             headers: [
                                "Content-Type": Matcher.term(matcher: "application/json(.*)?$", generate: "application/json")
                             ],
                             body: [
                                "name": Matcher.somethingLike(expectedLandmark.name),
                                "category": Matcher.term(matcher: Landmark.Category.allCases.map { $0.rawValue }.joined(separator: "|"),
                                                         generate: expectedLandmark.category.rawValue),
                                "city": Matcher.somethingLike(Faker().address.city()),
                                "state": Matcher.somethingLike(expectedLandmark.state),
                                "id": Matcher.somethingLike(expectedLandmark.id),
                                "isFeatured": Matcher.somethingLike(expectedLandmark.isFeatured),
                                "isFavorite": expectedLandmark.isFavorite,
                                "park": Matcher.somethingLike(expectedLandmark.park),
                                "coordinates": [
                                    "longitude": Matcher.somethingLike(expectedLandmark.locationCoordinate.longitude),
                                    "latitude": Matcher.somethingLike(expectedLandmark.locationCoordinate.latitude)
                                ],
                                "description": Matcher.somethingLike(expectedLandmark.description),
                                "imageName": Matcher.somethingLike("turtlerock")
                             ])

        hikesServiceProvider.run { [self] (testComplete) in
            service.setFavorite(to: true, on: expectedLandmark).sink {
                switch $0 {
                    case .success(let landmark):
                        XCTAssert(landmark.isFavorite)
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
