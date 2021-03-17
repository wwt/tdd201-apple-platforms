//
//  Pasta.swift
//  BigAwfulLegacySpaghettiMess
//
//  Created by thompsty on 3/17/21.
//

import Foundation

@objc public class Pasta: NSObject, Decodable {
    var name: String!
    var image: Data!
    var length: Int!

    var measurementLength: Measurement<UnitLength> {
        Measurement<UnitLength>.init(value: Double(length), unit: .inches)
    }
    public override var description: String {
        "// TODO"
    }

//    init(nme: String, imaeg: Data, length: Measurement<UnitLength>) {
//
//    }

//    init(name: String, image: Data, length: Int) {
//        self.name = name
//        self.image = image
//        self.length = length
//    }
}
