/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the details for a landmark.
*/

import SwiftUI
import Combine

struct LandmarkDetail: View {
    @EnvironmentObject var appModel: AppModel
    @ObservedObject private var viewModel = ViewModel()

    let inspection = Inspection<Self>()

    var landmark: Landmark
    var landmarkIndex: Int {
        appModel.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }

    var body: some View {
        ScrollView {
            MapView(coordinate: landmark.locationCoordinate)
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)

            CircleImage(image: landmark.image)

            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.name)
                        .font(.title)
                    FavoriteButton(isSet: $appModel.landmarks[landmarkIndex].isFavorite)
                }

                HStack {
                    Text(landmark.park)
                    Spacer()
                    Text(landmark.state)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Divider()

                Text("About \(landmark.name)")
                    .font(.title2)
                Text(landmark.description)
            }
            .padding()
        }
        .onChange(of: appModel.landmarks[landmarkIndex].isFavorite) { val in
            // NOTE: Call sink if you care about the value, use connect if it does not matter
            viewModel.hikesService?
                .setFavorite(to: val, on: appModel.landmarks[landmarkIndex])
                .makeConnectable()
                .connect()
                .store(in: &viewModel.subscribers)
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

extension LandmarkDetail {
    fileprivate final class ViewModel: ObservableObject {
        @DependencyInjected var hikesService: HikesServiceProtocol?
        var subscribers = Set<AnyCancellable>()
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static let appModel = AppModel()

    static var previews: some View {
        LandmarkDetail(landmark: appModel.landmarks[1])
            .environmentObject(appModel)
    }
}
