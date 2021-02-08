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
            if let json = try JSONSerialization.jsonObject(with: $0.data) as? [String: Any],
               let result = (json["result"] as? [String: Any]) {
                let data = try JSONSerialization.data(withJSONObject: result)
                return (data:data, response: $0.response)
            }
            return $0
        }.eraseToAnyPublisher()
    }
}
