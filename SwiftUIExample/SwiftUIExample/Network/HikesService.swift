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
}

extension HikesServiceProtocol where Self: RESTAPIProtocol {
    var fetchHikes: AnyPublisher<Result<[Hike], API.HikesService.FetchHikesError>, Never> {
        self.get(endpoint: "hikes") {
            $0.acceptingJSON()
                .sendingJSON()
        }.tryMap { (data, res) -> URLSession.ErasedDataTaskPublisher.Output in
            print("")
            return (data, res)
        }
        .map(\.data)
        .decode(type: [Hike].self, decoder: JSONDecoder())
        .map(Result.success)
        .catch { error in Just(.failure(.apiBorked(error))) }
        .eraseToAnyPublisher()
    }
}

extension API {
    struct HikesService: HikesServiceProtocol, RESTAPIProtocol {
        var baseURL = "http://localhost:3000/hikes"

        enum FetchHikesError: Error {
            case apiBorked(Error)
        }
    }
}
