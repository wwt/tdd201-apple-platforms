//
//  LandmarkRow.swift
//  SwiftUIExample
//
//  Created by Zach Frew on 5/21/21.
//

import SwiftUI

struct LandmarkRow: View {
    let landmark: Landmark

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_try
        let landmark = try! JSONDecoder().decode(Landmark.self, from: Data("""
{
    "name": "Turtle Rock",
    "category": "Rivers",
    "city": "Twentynine Palms",
    "state": "California",
    "id": 1001,
    "isFeatured": true,
    "isFavorite": true,
    "park": "Joshua Tree National Park",
    "coordinates": {
        "longitude": -116.166868,
        "latitude": 34.011286
    },
    "description": "Test Description",
    "imageName": "turtlerock"
}
""".utf8))
        LandmarkRow(landmark: landmark)

    }
}
