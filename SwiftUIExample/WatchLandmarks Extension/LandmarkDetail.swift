//
//  LandmarkDetail.swift
//  WatchLandmarks Extension
//
//  Created by Richard Gist on 4/6/21.
//

import SwiftUI

struct LandmarkDetail: View {
    @EnvironmentObject var appModel: AppModel
    var landmark: Landmark
    let inspection = Inspection<Self>()

    var landmarkIndex: Int {
        appModel.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }

    var body: some View {
        ScrollView {
            VStack {
                CircleImage(image: landmark.image.resizable())
                    .scaledToFit()
                Text(landmark.name)
                    .font(.headline)
                    .lineLimit(0)
                Toggle(isOn: $appModel.landmarks[landmarkIndex].isFavorite) {
                    Text("Favorite")
                }
                Divider()
                Text(landmark.park)
                    .font(.caption)
                    .bold()
                    .lineLimit(0)
                Text(landmark.state)
                    .font(.caption)
                Divider()
                MapView(coordinate: landmark.locationCoordinate)
                    .scaledToFit()
            }.padding()
        }
        .onReceive(inspection.notice) { inspection.visit(self, $0) }
    }
}
