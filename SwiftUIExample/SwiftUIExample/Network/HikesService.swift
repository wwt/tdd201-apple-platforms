//
//  HikesService.swift
//  SwiftUIExample
//
//  Created by thompsty on 3/4/21.
//

import Foundation
import Combine

protocol HikesServiceProtocol {
    var fetchHikes: AnyPublisher<Result<[Hike], API.HikesService.FetchHikesError>, Never> { get }
    #warning("Error type on fetch landmarks weird?")
    var fetchLandmarks: AnyPublisher<Result<[Landmark], API.HikesService.FetchHikesError>, Never> { get }
}

extension HikesServiceProtocol where Self: RESTAPIProtocol {
    var fetchHikes: AnyPublisher<Result<[Hike], API.HikesService.FetchHikesError>, Never> {
        self.get(endpoint: "hikes") {
            $0.acceptingJSON()
                .sendingJSON()
        }.map(\.data)
        .decode(type: [Hike].self, decoder: JSONDecoder())
        .map(Result.success)
        .catch { error in Just(.failure(.apiBorked(error))) }
        .eraseToAnyPublisher()
    }

    var fetchLandmarks: AnyPublisher<Result<[Landmark], API.HikesService.FetchHikesError>, Never> {
        self.get(endpoint: "landmarks") {
            $0.acceptingJSON()
                .sendingJSON()
        }.map(\.data)
        .decode(type: [Landmark].self, decoder: JSONDecoder())
        .map(Result.success)
        .catch { error in Just(.failure(.apiBorked(error))) }
        .eraseToAnyPublisher()
    }
}

extension API {
    struct HikesService: HikesServiceProtocol, RESTAPIProtocol {
        var baseURL = "http://localhost:3000"

        enum FetchHikesError: Error {
            case apiBorked(Error)
        }
    }
}
