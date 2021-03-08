/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Storage for model data.
*/

import Foundation
import Combine

final class AppModel: ObservableObject {
    @Published var landmarks: [Landmark] = []
    var hikes: [Hike] = []
    @Published var profile = Profile.default

    var features: [Landmark] {
        landmarks.filter { $0.isFeatured }
    }

    var categories: [String: [Landmark]] {
        Dictionary(
            grouping: landmarks,
            by: { $0.category.rawValue }
        )
    }
}
