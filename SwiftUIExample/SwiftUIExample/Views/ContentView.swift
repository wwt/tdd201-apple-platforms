/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing featured landmarks above a list of all of the landmarks.
 */

import SwiftUI
import Combine

struct ContentView: View {
    let inspection = Inspection<Self>() // Enabling testability
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        TabView {
            CategoryHome().tabItem { Label("Featured", systemImage: "star") }
            LandmarkList().tabItem { Label("List", systemImage: "list.bullet") }
        }
        .onAppear {
            _ = ViewModel().hikeService?.fetchHikes
                .sink { result in
                    if case .success(let hikes) = result {
                        appModel.hikes = hikes
                    }
                }
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
    }
}

fileprivate extension ContentView {
    final class ViewModel: ObservableObject {
        @DependencyInjected var hikeService: HikesServiceProtocol?
        var subscribers = Set<AnyCancellable>()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 12 mini")
                .environmentObject(AppModel())
        }
    }
}
