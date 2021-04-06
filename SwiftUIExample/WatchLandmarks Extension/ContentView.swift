//
//  ContentView.swift
//  WatchLandmarks Extension
//
//  Created by Richard Gist on 4/6/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkDetail(landmark: Landmark.createForTests(id: 1,
                                                         name: "foo",
                                                         park: "faa",
                                                         state: "ssoo",
                                                         description: "saa",
                                                         isFavorite: true,
                                                         isFeatured: false,
                                                         category: .lakes,
                                                         coordinates: .init(latitude: 100, longitude: 12)))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Landmark {
    static func createForTests (id: Int,
                                name: String,
                                park: String,
                                state: String,
                                description: String,
                                isFavorite: Bool,
                                isFeatured: Bool,
                                category: Landmark.Category,
                                coordinates: Landmark.Coordinates,
                                imageName: String = "turtlerock") -> Landmark {
        do {
            return try JSONDecoder().decode(Landmark.self,
                                            from: try JSONSerialization.data(withJSONObject: [
                                                "name": name,
                                                "category": category.rawValue,
                                                "state": state,
                                                "id": id,
                                                "isFeatured": isFeatured,
                                                "isFavorite": isFavorite,
                                                "park": park,
                                                "coordinates": [
                                                    "longitude": coordinates.longitude,
                                                    "latitude": coordinates.latitude
                                                ],
                                                "description": description,
                                                "imageName": imageName
                                            ]))
        } catch let err {
            fatalError(err.localizedDescription)
        }
    }
}
