//
//  LandmarkList.swift
//  SwiftUIExample
//
//  Created by Richard Gist on 4/8/21.
//

import SwiftUI
import Combine

struct LandmarkList: View {
    let inspection = Inspection<Self>() // Enabling testability
    @EnvironmentObject var appModel: AppModel
    @ObservedObject private var viewModel = ViewModel()
    @State private var isFavoritesOnly = false
    private var landmarks: [Landmark] {
        isFavoritesOnly ? appModel.landmarks.filter(\.isFavorite) : appModel.landmarks
    }

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $isFavoritesOnly) {
                    Text("Favorites only")
                }
                ForEach(landmarks) { landmark in
                    NavigationLink(
                        destination: LandmarkDetail(landmark: landmark)) {
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
        }
        .onAppear {
            viewModel.hikeService?.fetchLandmarks
                .tryMap { try $0.get() }
                .catch { _ in Empty<[Landmark], Never>() }
                .receive(on: DispatchQueue.main)
                .assign(to: \.landmarks, on: appModel)
                .store(in: &viewModel.subscribers)
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
    }
}

fileprivate extension LandmarkList {
    final class ViewModel: ObservableObject {
        @DependencyInjected var hikeService: HikesServiceProtocol?
        var subscribers = Set<AnyCancellable>()
    }
}
