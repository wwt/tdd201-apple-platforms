//
//  BaseAPI.swift
//  CombineWithREST
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import Swinject

struct API {
    enum URLError: Error {
        case unableToCreateURL
    }
    enum AuthorizationError:Error {
        case unauthorized
    }
}
