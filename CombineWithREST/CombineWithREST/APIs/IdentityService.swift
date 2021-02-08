//
//  IdentityService.swift
//  CombineWithREST
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import Combine



//protocol IdentityServiceProtocol {
//    var fetchProfile: AnyPublisher<Result<User.Profile, API.IdentityService.FetchProfileError>, Never> { get }
//}
//
//extension IdentityServiceProtocol where Self: RESTAPIProtocol {
//
//    var fetchProfile: AnyPublisher<Result<User.Profile, API.IdentityService.FetchProfileError>, Never> {
//        self.get(endpoint: "/me", requestModifier: {
//            $0.addingBearerAuthorization(token: User.accessToken)
//                .acceptingJSON()
//                .sendingJSON()
//        }).retryOnceOnUnauthorizedResponse(chainedRequest: refresh)
//        .unwrapResultJSONFromAPI()
//        .map { $0.data }
//        .decodeFromJson(User.Profile.self)
//        .receive(on: DispatchQueue.main)
//        .map(Result.success)
//        .catch { error in Just(.failure((error as? API.IdentityService.FetchProfileError) ?? .apiBorked)) }
//        .eraseToAnyPublisher()
//    }
//
//    private var refresh: URLSession.ErasedDataTaskPublisher {
//        post(endpoint: "/auth/refresh", body: try? JSONSerialization.data(withJSONObject: ["refreshToken": User.refreshToken], options: []), requestModifier: {
//            $0.acceptingJSON()
//                .sendingJSON()
//        }).unwrapResultJSONFromAPI()
//        .tryMap { v -> URLSession.ErasedDataTaskPublisher.Output in
//            let json = try? JSONSerialization.jsonObject(with: v.data, options: []) as? [String: Any]
//            guard let accessToken = json?["accessToken"] as? String else {
//                throw API.AuthorizationError.unauthorized
//            }
//            User.accessToken = accessToken
//            return v
//        }.eraseToAnyPublisher()
//    }
//}
//
extension API {
    struct IdentityService: RESTAPIProtocol {
//    : IdentityServiceProtocol, RESTAPIProtocol {
        var baseURL = "https://some.identityservice.com/api"

        enum FetchProfileError: Error {
            case apiBorked(Error)
        }

        
        var fetchProfile: AnyPublisher<Result<User.Profile, FetchProfileError>, Never> {
            self.get(endpoint: "me") {
                $0.acceptingJSON()
                    .sendingJSON()
                    .addingBearerAuthorization(token: User.accessToken)
            }.retryOnceOnUnauthorizedResponse(chainedRequest: refresh)
            .map(\.data)
            .decode(type: User.Profile.self, decoder: JSONDecoder())
            .map(Result.success)
            .catch { error in Just(.failure(.apiBorked(error))) }
            .eraseToAnyPublisher()
        }
        
        private var refresh: URLSession.ErasedDataTaskPublisher {
            self.post(endpoint: "auth/refresh",
                      body: try? JSONSerialization.data(withJSONObject: ["refreshToken": User.refreshToken]))
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
}
