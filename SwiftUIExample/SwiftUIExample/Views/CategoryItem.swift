//
//  CategoryItem.swift
//  SwiftUIExample
//
//  Created by Zach Frew on 5/21/21.
//

import SwiftUI

struct CategoryItem: View {
    let landmark: Landmark

    var body: some View {
        VStack(alignment: .leading) {
            landmark.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text(landmark.name)
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}

struct CategoryItem_Previews: PreviewProvider {
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
        return CategoryItem(landmark: landmark)
    }
}
