//
//  LandmarkExtensions.swift
//  WatchLandmarks_FrameworkTests
//
//  Created by Richard Gist on 4/6/21.
//

@testable import WatchLandmarks_Framework

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
