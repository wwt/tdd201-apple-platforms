//
//  BaseAPI.swift
//  SwiftUIExample
//
//  Created by thompsty on 3/4/21.
//

import Foundation
import Swinject

enum API {
    enum URLError: Error {
        case unableToCreateURL
    }
    enum AuthorizationError: Error {
        case unauthorized
    }
}
