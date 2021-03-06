//
//  RESTAPIProtocol.swift
//  CombineWithREST
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import Combine

protocol RESTAPIProtocol {
    typealias RequestModifier = ((URLRequest) -> URLRequest)

    var baseURL: String { get }
    var urlSession: URLSession { get }
}

extension RESTAPIProtocol {
    var urlSession: URLSession { URLSession.shared }

    func get(endpoint: String, requestModifier: @escaping RequestModifier = { $0 }) -> URLSession.ErasedDataTaskPublisher {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint) else {
            return Fail<URLSession.DataTaskPublisher.Output, Error>(error: API.URLError.unableToCreateURL).eraseToAnyPublisher()
        }
        return createPublisher(for: URLRequest(url: url), requestModifier: requestModifier)
    }

    func put(endpoint: String, body: Data? = nil, requestModifier: @escaping RequestModifier = { $0 }) -> URLSession.ErasedDataTaskPublisher {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint) else {
            return Fail<URLSession.DataTaskPublisher.Output, Error>(error: API.URLError.unableToCreateURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = body
        return createPublisher(for: request, requestModifier: requestModifier)
    }

    func post(endpoint: String, body: Data? = nil, requestModifier: @escaping RequestModifier = { $0 }) -> URLSession.ErasedDataTaskPublisher {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint) else {
            return Fail<URLSession.DataTaskPublisher.Output, Error>(error: API.URLError.unableToCreateURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        return createPublisher(for: request, requestModifier: requestModifier)
    }

    func patch(endpoint: String, body: Data? = nil, requestModifier: @escaping RequestModifier = { $0 }) -> URLSession.ErasedDataTaskPublisher {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint) else {
            return Fail<URLSession.DataTaskPublisher.Output, Error>(error: API.URLError.unableToCreateURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.httpBody = body
        return createPublisher(for: request, requestModifier: requestModifier)
    }

    func delete(endpoint: String, requestModifier: @escaping RequestModifier = { $0 }) -> URLSession.ErasedDataTaskPublisher {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint) else {
            return Fail<URLSession.DataTaskPublisher.Output, Error>(error: API.URLError.unableToCreateURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return createPublisher(for: request, requestModifier: requestModifier)
    }

    func createPublisher(for request: URLRequest, requestModifier:@escaping RequestModifier) -> URLSession.ErasedDataTaskPublisher {
        Just(request)
            .setFailureType(to: Error.self)
            .flatMap { [self] in
                urlSession.erasedDataTaskPublisher(for: requestModifier($0))
            }.eraseToAnyPublisher()
    }

}
