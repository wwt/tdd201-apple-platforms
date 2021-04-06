//
//  LandmarkDetail.swift
//  WatchLandmarks Extension
//
//  Created by Richard Gist on 4/6/21.
//

import SwiftUI

struct LandmarkDetail: View {
    @EnvironmentObject var modelData: AppModel
    var landmark: Landmark

    var landmarkIndex: Int {
        modelData.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }

    var body: some View {
        CircleImage(image: landmark.image.resizable())
            .scaledToFill()
    }
}
