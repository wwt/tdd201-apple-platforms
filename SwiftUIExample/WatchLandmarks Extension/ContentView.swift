//
//  ContentView.swift
//  WatchLandmarks Extension
//
//  Created by Richard Gist on 4/6/21.
//

import SwiftUI
import Combine

#warning("WE WANT TO CHANGE THIS so that the app itself does the loading of data before passing on to the watch")
#warning("or...do we????")

struct ContentView: View {
    @EnvironmentObject var appModel: AppModel
    @ObservedObject private var viewModel = ViewModel()
    @State private var hikesResult: Result<[Hike], API.HikesService.Error>? {
        didSet {
            switch hikesResult {
                case .success(let hikes): appModel.hikes = hikes
                case .failure: showAlert = true
                default: break
            }
        }
    }
    @State private var landmarksResult: Result<[Landmark], API.HikesService.Error>? {
        didSet {
            switch landmarksResult {
                case .success(let landmarks): appModel.landmarks = landmarks
                case .failure: showAlert = true
                default: break
            }
        }
    }
    @State private var showAlert = false

    var body: some View {
        Group {
            switch landmarksResult {
                case .none:
                    ProgressView()
                default:
                    LandmarkList()
            }
        }
        .onAppear {
            viewModel.hikesService?.fetchHikes.map(Optional.some).receive(on: DispatchQueue.main)
                .assign(to: \.hikesResult, on: self).store(in: &viewModel.subscribers)

            viewModel.hikesService?.fetchLandmarks.map(Optional.some).receive(on: DispatchQueue.main)
                .assign(to: \.landmarksResult, on: self).store(in: &viewModel.subscribers)
        }
        .alert(isPresented: $showAlert) {
            let errors: [String] = {
                var allErrors = [String]()
                if case .failure(let err) = hikesResult,
                   case .apiBorked(let underlyingError) = err { allErrors.append(underlyingError.localizedDescription) }
                if case .failure(let err) = landmarksResult,
                   case .apiBorked(let underlyingError) = err { allErrors.append(underlyingError.localizedDescription) }
                return allErrors
            }()
            return Alert(title: Text(errors.joined(separator: "\n")))
        }
    }
}

extension ContentView {
    fileprivate final class ViewModel: ObservableObject {
        @DependencyInjected var hikesService: HikesServiceProtocol?
        var subscribers = Set<AnyCancellable>()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
