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
    @State private var selection: Tab = .featured
    @State private var hikesResult: Result<[Hike], API.HikesService.FetchHikesError>? {
        didSet {
            switch hikesResult {
                case .success(let hikes): appModel.hikes = hikes
                case .failure: showAlert = true
                default: break
            }
        }
    }
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

    var body: some View {
        TabView(selection: $selection) {
            switch (hikesResult, landmarksResult) {
                case (.none, .none): ProgressView()
                default:
                    CategoryHome()
                        .tabItem {
                            Label("Featured", systemImage: "star")
                        }
                        .tag(Tab.featured)

                    LandmarkList()
                        .tabItem {
                            Label("List", systemImage: "list.bullet")
                        }
                        .tag(Tab.list)
            }
        }
        .onAppear {
            viewModel.hikesService?.fetchHikes.map { Optional($0) }.receive(on: DispatchQueue.main)
                .assign(to: \.hikesResult, on: self).store(in: &viewModel.subscribers)

            viewModel.hikesService?.fetchLandmarks.map { Optional($0) }.receive(on: DispatchQueue.main)
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
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

extension ContentView {
    fileprivate final class ViewModel: ObservableObject {
        @DependencyInjected var hikesService: HikesServiceProtocol?
        var subscribers = Set<AnyCancellable>()
    }

    enum Tab {
        case featured
        case list
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppModel())
    }
}
