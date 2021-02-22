//
//  CategoryHome.swift
//  SwiftUIExample
//
//  Created by Heather Meadow on 2/19/21.
//

import SwiftUI

struct CategoryHome: View {
    @EnvironmentObject var modelData: ModelData
    let inspection = Inspection<Self>()

    var body: some View {
        NavigationView {
            List {
                modelData.features[0].image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                let list = modelData.categories.sorted(by: { $0.key < $1.key })
                ForEach(Array(list.enumerated()), id: \.offset) {
                    CategoryRow(categoryName: $0.element.key, items: $0.element.value)
                }
                .listRowInsets(EdgeInsets())
            }.navigationTitle("Featured")
        }.onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
            .environmentObject(ModelData())
    }
}
