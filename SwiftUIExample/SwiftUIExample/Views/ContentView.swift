/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing featured landmarks above a list of all of the landmarks.
 */

import SwiftUI
import Combine

struct ContentView: View {
    let inspection = Inspection<Self>()

    var body: some View {
        TabView {
            CategoryHome().tabItem { Label("Featured", systemImage: "star") }
            LandmarkList().tabItem { Label("List", systemImage: "list.bullet") }
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
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
