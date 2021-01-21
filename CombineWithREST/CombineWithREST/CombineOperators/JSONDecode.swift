//
//  JSONDecode.swift
//  CombineWithREST
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import Combine

extension Publisher {
    public func decodeFromJson<Item>(_ type: Item.Type) -> Publishers.Decode<Self, Item, JSONDecoder> where Item : Decodable, Self.Output == JSONDecoder.Input {
        return decode(type: type, decoder: JSONDecoder())
    }
}
