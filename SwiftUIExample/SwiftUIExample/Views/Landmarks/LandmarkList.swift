//
//  LandmarkList.swift
//  SwiftUIExample
//
//  Created by Richard Gist on 4/8/21.
//

import SwiftUI

struct LandmarkList: View {
    let inspection = Inspection<Self>() // Enabling testability
    @EnvironmentObject var appModel: AppModel
    @State private var isFavoritesOnly = false

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $isFavoritesOnly) {
                    Text("Favorites only")
                }
                ForEach(appModel.landmarks.filter({$0.isFavorite || !isFavoritesOnly})) { landmark in
                    NavigationLink(
                        destination: LandmarkDetail(landmark: landmark)) {
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
        }
        .onReceive(inspection.notice) {
            self.inspection.visit(self, $0)
        }
    }
}
