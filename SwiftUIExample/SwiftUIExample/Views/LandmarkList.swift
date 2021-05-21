//
//  LandmarkList.swift
//  SwiftUIExample
//
//  Created by Zach Frew on 5/21/21.
//

import Combine
import SwiftUI

struct LandmarkList: View {
    @EnvironmentObject var appModel: AppModel
    @ObservedObject fileprivate var viewModel = ViewModel()
    @State private var landmarksResult: Result<[Landmark], API.HikesService.Error>? {
        didSet {
            switch landmarksResult {
                case .success(let landmarks):
                    appModel.landmarks = landmarks
                case .failure:
                    showAlert = true
                case .none:
                    break
            }
        }
    }
    @State private var showAlert = false
    @State private var showingFavoritesOnly = false
    let inspection = Inspection<Self>()

    private var filteredLandmarks: [Landmark] {
        appModel.landmarks.filter { (!showingFavoritesOnly || $0.isFavorite) }
    }

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showingFavoritesOnly) {
                    Text("Favorites only")
                }

                ForEach(filteredLandmarks) { landmark in
                    NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
        .onAppear {
            viewModel.hikeService?.fetchLandmarks
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .map { Optional($0) }
                .assign(to: \.landmarksResult, on: self)
                .store(in: &viewModel.subscribers)
        }
        .alert(isPresented: $showAlert) {
            let error: String = {
                if case .failure(let err) = landmarksResult,
                   case .apiBorked(let underlyingError) = err { return underlyingError.localizedDescription }
                return ""
            }()
            
            return Alert(title: Text(error))
        }
    }
}

extension LandmarkList {
    fileprivate final class ViewModel: ObservableObject {
        @DependencyInjected var hikeService: HikesServiceProtocol?
        var subscribers = Set<AnyCancellable>()
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
    }
}
