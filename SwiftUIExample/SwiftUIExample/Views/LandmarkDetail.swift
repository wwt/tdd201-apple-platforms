//
//  LandmarkDetail.swift
//  SwiftUIExample
//
//  Created by david.roff on 5/20/21.
//

import SwiftUI

struct LandmarkDetail: View {
    let landmark: Landmark
    let inspection = Inspection<Self>()

    var body: some View {
        ScrollView {
            Text(landmark.name)
            Text(landmark.park)
            Text(landmark.state)
            Text("About \(landmark.name)")
            Text(landmark.description)
            MapView(coordinate: landmark.locationCoordinate)
            CircleImage(image: landmark.image)
            FavoriteButton(isSet: landmark.isFavorite)
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
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
        LandmarkDetail(landmark: landmark)
    }
}
