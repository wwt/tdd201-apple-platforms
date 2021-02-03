//
//  APIOperators.swift
//  CombineWithREST
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import Combine

extension URLSession.ErasedDataTaskPublisher {
    func unwrapResultJSONFromAPI() -> Self {
        tryMap {
            if let json = try JSONSerialization.jsonObject(with: $0.data, options: []) as? [String: Any],
               let result = (json["result"] as? [String: Any]) {
                let data = try JSONSerialization.data(withJSONObject: result, options: [])
                return (data:data, response: $0.response)
            }
            return $0
        }.eraseToAnyPublisher()
    }
}
