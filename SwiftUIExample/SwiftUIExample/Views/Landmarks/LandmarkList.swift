/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of landmarks.
*/

import SwiftUI
import Combine

struct LandmarkList: View {
    @EnvironmentObject var appModel: AppModel
    @ObservedObject private var viewModel = ViewModel()
    @State private var showFavoritesOnly = false
    @State private var landmarksResult: Result<[Landmark], API.HikesService.FetchHikesError>? {
        didSet {
            switch landmarksResult {
                case .success(let landmarks): appModel.landmarks = landmarks
                case .failure: showAlert = true
                default: break
            }
        }
    }
    @State private var showAlert = false

    internal let inspection = Inspection<Self>()

    var filteredLandmarks: [Landmark] {
        appModel.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }

                ForEach(filteredLandmarks) { landmark in
                    NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
            .navigationTitle("Landmarks")
        }
        .onAppear {
            viewModel.hikesService?.fetchLandmarks.map { Optional($0) }.receive(on: DispatchQueue.main)
                .assign(to: \.landmarksResult, on: self).store(in: &viewModel.subscribers)
        }
        .alert(isPresented: $showAlert) {
            let error: String = {
                if case .failure(let err) = landmarksResult,
                   case .apiBorked(let underlyingError) = err { return underlyingError.localizedDescription }
                return ""
            }()
            return Alert(title: Text(error))
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

extension LandmarkList {
    fileprivate class ViewModel: ObservableObject {
        @DependencyInjected var hikesService: HikesServiceProtocol?
        var subscribers = Set<AnyCancellable>()
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
            .environmentObject(AppModel())
    }
}
