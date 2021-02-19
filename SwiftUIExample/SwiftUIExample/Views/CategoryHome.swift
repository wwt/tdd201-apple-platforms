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
                ForEach(modelData.categories.keys.sorted(), id: \.self) { key in
                    Text(key)
                }
            }
                .navigationTitle("Featured")
        }.onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
    }
}
