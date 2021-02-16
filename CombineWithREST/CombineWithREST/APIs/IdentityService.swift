//
//  IdentityService.swift
//  CombineWithREST
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import Combine

protocol IdentityServiceProtocol {
    var fetchProfile: AnyPublisher<Result<User.Profile, API.IdentityService.FetchProfileError>, Never> { get }
}

extension IdentityServiceProtocol where Self: RESTAPIProtocol {
    var fetchProfile: AnyPublisher<Result<User.Profile, API.IdentityService.FetchProfileError>, Never> {
        self.get(endpoint: "me") {
            $0.acceptingJSON()
                .sendingJSON()
                .addingBearerAuthorization(token: User.accessToken)
        }.retryOnceOnUnauthorizedResponse(chainedRequest: refresh)
        .map(\.data)
        .decodeFromJson(User.Profile.self)
        .map(Result.success)
        .catch { error in Just(.failure(.apiBorked(error))) }
        .eraseToAnyPublisher()
    }

    private var refresh: URLSession.ErasedDataTaskPublisher {
        self.post(endpoint: "auth/refresh",
                  body: try? JSONSerialization.data(withJSONObject: ["refreshToken": User.refreshToken])) {
            $0.acceptingJSON()
                .sendingJSON()
        }.catchUnauthorizedResponse()
        .unwrapResultJSONFromAPI()
        .tryMap { args -> URLSession.ErasedDataTaskPublisher.Output in
            let json = try JSONSerialization.jsonObject(with: args.data) as? [String: Any]
            guard let accessToken = json?["accessToken"] as? String else {
                throw API.AuthorizationError.unauthorized
            }
            User.accessToken = accessToken
            return args
        }.eraseToAnyPublisher()
    }
}

extension API {
    struct IdentityService: IdentityServiceProtocol, RESTAPIProtocol {
        var baseURL = "https://some.identityservice.com/api"

        enum FetchProfileError: Error {
            case apiBorked(Error)
        }
    }
}
