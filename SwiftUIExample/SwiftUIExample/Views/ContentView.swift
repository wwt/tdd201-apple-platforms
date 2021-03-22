/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing featured landmarks above a list of all of the landmarks.
 */

import SwiftUI
import Combine

struct ContentView: View {

    var body: some View {
        EmptyView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppModel())
    }
}
