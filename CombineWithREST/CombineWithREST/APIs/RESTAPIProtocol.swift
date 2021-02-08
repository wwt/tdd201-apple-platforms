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
    
    func get(endpoint: String, requestModifier: RequestModifier = { $0 }) -> URLSession.ErasedDataTaskPublisher {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint) else {
            return Fail<URLSession.DataTaskPublisher.Output, Error>(error: API.URLError.unableToCreateURL).eraseToAnyPublisher()
        }
        return urlSession.erasedDataTaskPublisher(for: requestModifier(URLRequest(url: url)))
    }
    
    func put(endpoint:String, body:Data? = nil, requestModifier: RequestModifier = { $0 }) -> URLSession.ErasedDataTaskPublisher {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint) else {
            return Fail<URLSession.DataTaskPublisher.Output, Error>(error: API.URLError.unableToCreateURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = body
        return urlSession.erasedDataTaskPublisher(for: requestModifier(request))
    }
    
    func post(endpoint:String, body:Data? = nil, requestModifier: RequestModifier = { $0 }) -> URLSession.ErasedDataTaskPublisher {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint) else {
            return Fail<URLSession.DataTaskPublisher.Output, Error>(error: API.URLError.unableToCreateURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        return urlSession.erasedDataTaskPublisher(for: requestModifier(request))
    }
    
    func patch(endpoint:String, body:Data? = nil, requestModifier: RequestModifier = { $0 }) -> URLSession.ErasedDataTaskPublisher {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint) else {
            return Fail<URLSession.DataTaskPublisher.Output, Error>(error: API.URLError.unableToCreateURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.httpBody = body
        return urlSession.erasedDataTaskPublisher(for: requestModifier(request))
    }
    
    func delete(endpoint:String, requestModifier: RequestModifier = { $0 }) -> URLSession.ErasedDataTaskPublisher {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint) else {
            return Fail<URLSession.DataTaskPublisher.Output, Error>(error: API.URLError.unableToCreateURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return urlSession.erasedDataTaskPublisher(for: requestModifier(request))
    }
}
