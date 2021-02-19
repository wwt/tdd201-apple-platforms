//
//  CategoryRow.swift
//  SwiftUIExample
//
//  Created by Heather Meadow on 2/19/21.
//

import Foundation
import SwiftUI

struct CategoryRow: View {
    var categoryName: String
    var items: [Landmark]

    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { landmark in
                        Text(landmark.name)
                    }
                }
            }.frame(height: 185)
        }
    }
}
