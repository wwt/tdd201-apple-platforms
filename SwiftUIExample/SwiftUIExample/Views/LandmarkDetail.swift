//
//  LandmarkDetail.swift
//  SwiftUIExample
//
//  Created by david.roff on 5/20/21.
//

import Combine
import SwiftUI

struct LandmarkDetail: View {
    @EnvironmentObject var appModel: AppModel
    @ObservedObject fileprivate var viewModel = ViewModel()
    let landmark: Landmark
    let inspection = Inspection<Self>()

    var landmarkIndex: Int! {
        appModel.landmarks.firstIndex(where: { $0.id == landmark.id })
    }

    var body: some View {
        ScrollView {
            Text(landmark.name)
            Text(landmark.park)
            Text(landmark.state)
            Text("About \(landmark.name)")
            Text(landmark.description)
            MapView(coordinate: landmark.locationCoordinate)
            CircleImage(image: landmark.image)
            FavoriteButton(isSet: $appModel.landmarks[landmarkIndex].isFavorite)
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
        .onChange(of: appModel.landmarks[landmarkIndex].isFavorite) { value in
            viewModel.hikeService?.setFavorite(to: value, on: appModel.landmarks[landmarkIndex])
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .makeConnectable()
                .connect()
                .store(in: &viewModel.subscribers)
        }
    }
}

extension LandmarkDetail {
    fileprivate final class ViewModel: ObservableObject {
        @DependencyInjected var hikeService: HikesServiceProtocol?
        var subscribers = Set<AnyCancellable>()
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_try
        let landmark = try! JSONDecoder().decode(Landmark.self, from: Data("""
{
    "name": "Turtle Rock",
    "category": "Rivers",
    "city": "Twentynine Palms",
    "state": "California",
    "id": 1001,
    "isFeatured": true,
    "isFavorite": true,
    "park": "Joshua Tree National Park",
    "coordinates": {
        "longitude": -116.166868,
        "latitude": 34.011286
    },
    "description": "Test Description",
    "imageName": "turtlerock"
}
""".utf8))
        LandmarkDetail(landmark: landmark)
    }
}
