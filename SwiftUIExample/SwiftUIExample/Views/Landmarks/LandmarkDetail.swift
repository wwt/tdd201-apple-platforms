//
//  LandmarkDetail.swift
//  SwiftUIExample
//
//  Created by Richard Gist on 4/8/21.
//

import SwiftUI

struct LandmarkDetail: View {
    let inspection = Inspection<Self>() // Enabling testability
    let landmark: Landmark
    @EnvironmentObject var appModel: AppModel
    var landmarkIndex: Int! {
        appModel.landmarks.firstIndex(where: { $0.id == landmark.id })
    }

    var body: some View {
        ScrollView {
            MapView(coordinate: landmark.locationCoordinate)
            CircleImage(image: landmark.image)
            Text(landmark.name)
            FavoriteButton(isSet: $appModel.landmarks[landmarkIndex].isFavorite)
            Text(landmark.park)
            Text(landmark.state)
            Text("About \(landmark.name)")
            Text(landmark.description)
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
    }
}
