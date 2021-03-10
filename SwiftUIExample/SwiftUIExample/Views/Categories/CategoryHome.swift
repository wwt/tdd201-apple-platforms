/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 A view showing featured landmarks above a list of landmarks grouped by category.
 */

import SwiftUI

struct CategoryHome: View {
    @EnvironmentObject var appModel: AppModel
    @State private var showingProfile = false
    internal let inspection = Inspection<Self>()

    var body: some View {
        NavigationView {
            List {
                appModel.features.first?.image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                let list = appModel.categories.sorted(by: { $0.key < $1.key })
                ForEach(Array(list.enumerated()), id: \.offset) {
                    CategoryRow(categoryName: $0.element.key, items: $0.element.value)
                }
                .listRowInsets(EdgeInsets())
            }
            .padding(1)
            .navigationTitle("Featured")
            .toolbar {
                Button { showingProfile.toggle() }
                    label: {
                        Image(systemName: "person.crop.circle")
                            .accessibilityLabel("User Profile")
                    }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environmentObject(appModel)
            }
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
            .environmentObject(AppModel())
    }
}
