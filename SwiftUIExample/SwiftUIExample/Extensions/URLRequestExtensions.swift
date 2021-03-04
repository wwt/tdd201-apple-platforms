//
//  URLRequestExtensions.swift
//  SwiftUIExample
//
//  Created by thompsty on 3/4/21.
//

import Foundation
extension URLRequest {
    func acceptingJSON() -> URLRequest {
        var request = self
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    func sendingJSON() -> URLRequest {
        var request = self
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
