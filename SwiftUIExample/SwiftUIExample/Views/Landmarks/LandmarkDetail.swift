//
//  LandmarkDetail.swift
//  SwiftUIExample
//
//  Created by Richard Gist on 4/8/21.
//

import SwiftUI
import Combine

struct LandmarkDetail: View {
    let inspection = Inspection<Self>() // Enabling testability
    let landmark: Landmark
    @EnvironmentObject var appModel: AppModel
    @ObservedObject private var viewModel = ViewModel()
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
        .onChange(of: appModel.landmarks[landmarkIndex].isFavorite) { change in
            viewModel.hikeService?.setFavorite(to: change, on: appModel.landmarks[landmarkIndex])
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .makeConnectable()
                .connect()
                .store(in: &viewModel.subscribers)
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
    }
}

fileprivate extension LandmarkDetail {
    final class ViewModel: ObservableObject {
        @DependencyInjected var hikeService: HikesServiceProtocol?
        var subscribers = Set<AnyCancellable>()
    }
}
