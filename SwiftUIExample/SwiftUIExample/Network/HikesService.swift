//
//  HikesService.swift
//  SwiftUIExample
//
//  Created by thompsty on 3/4/21.
//

import Foundation
import Combine

protocol HikesServiceProtocol {
    var fetchHikes: AnyPublisher<Result<[Hike], API.HikesService.Error>, Never> { get }
    var fetchLandmarks: AnyPublisher<Result<[Landmark], API.HikesService.Error>, Never> { get }

    func setFavorite(to: Bool, on landmark: Landmark) -> AnyPublisher<Result<Landmark, API.HikesService.Error>, Never>
}

extension HikesServiceProtocol where Self: RESTAPIProtocol {
    var fetchHikes: AnyPublisher<Result<[Hike], API.HikesService.Error>, Never> {
        self.get(endpoint: "hikes") {
            $0.acceptingJSON()
                .sendingJSON()
        }.map(\.data)
        .decode(type: [Hike].self, decoder: JSONDecoder())
        .map(Result.success)
        .catch { error in Just(.failure(.apiBorked(error))) }
        .eraseToAnyPublisher()
    }

    var fetchLandmarks: AnyPublisher<Result<[Landmark], API.HikesService.Error>, Never> {
        self.get(endpoint: "landmarks") {
            $0.acceptingJSON()
                .sendingJSON()
        }.map(\.data)
        .decode(type: [Landmark].self, decoder: JSONDecoder())
        .map(Result.success)
        .catch { error in Just(.failure(.apiBorked(error))) }
        .eraseToAnyPublisher()
    }

    func setFavorite(to: Bool, on landmark: Landmark) -> AnyPublisher<Result<Landmark, API.HikesService.Error>, Never> {
        self.put(endpoint: "landmarks/\(landmark.id)/favorite", body: try? JSONSerialization.data(withJSONObject: ["isFavorite": to])) {
            $0.acceptingJSON()
                .sendingJSON()
        }.map(\.data)
        .decode(type: Landmark.self, decoder: JSONDecoder())
        .map(Result.success)
        .catch { error in Just(.failure(.apiBorked(error))) }
        .eraseToAnyPublisher()
    }
}

extension API {
    struct HikesService: HikesServiceProtocol, RESTAPIProtocol {
        var baseURL = "http://localhost:3000"

        enum Error: Swift.Error {
            case apiBorked(Swift.Error)
        }
    }
}
