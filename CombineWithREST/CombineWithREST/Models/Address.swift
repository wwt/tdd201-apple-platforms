//
//  Address.swift
//  CombineWithREST
//
//  Created by thompsty on 1/20/21.
//

import Foundation

struct Address : Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case line1
        case line2
        case city
        case state = "stateOrProvince"
        case zip = "zipCode"
    }
    
    var line1: String
    var line2: String
    var city: String
    var state: String
    var zip: String
}
