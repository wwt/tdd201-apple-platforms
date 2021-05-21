/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing featured landmarks above a list of all of the landmarks.
 */

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var appModel: AppModel
    @ObservedObject private var viewModel = ViewModel()
    @State private var hikesResult: Result<[Hike], API.HikesService.Error>? {
        didSet {
            switch hikesResult {
                case .success(let hikes):
                    appModel.hikes = hikes
                case .failure:
                    showAlert = true
                case .none:
                    break
            }
        }
    }
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
    let inspection = Inspection<Self>()

    var body: some View {
        TabView {
            switch (landmarksResult, hikesResult) {
                case (.none, .none):
                    ProgressView()
                    EmptyView()
                default:
                    CategoryHome()
                        .tabItem {
                            Label("Featured", systemImage: "star")
                        }
                    LandmarkList()
                        .tabItem {
                            Label("List", systemImage: "list.bullet")
                        }
            }
        }
        .onAppear {
            viewModel.hikeService?.fetchLandmarks
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .map { Optional($0) }
                .assign(to: \.landmarksResult, on: self)
                .store(in: &viewModel.subscribers)

            viewModel.hikeService?.fetchHikes
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .map { Optional($0) }
                .assign(to: \.hikesResult, on: self)
                .store(in: &viewModel.subscribers)
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
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

extension ContentView {
    fileprivate final class ViewModel: ObservableObject {
        @DependencyInjected var hikeService: HikesServiceProtocol?
        var subscribers = Set<AnyCancellable>()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppModel())
    }
}
