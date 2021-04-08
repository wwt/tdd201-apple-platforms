//
//  LandmarkRow.swift
//  SwiftUIExample
//
//  Created by Richard Gist on 4/8/21.
//

import SwiftUI

struct LandmarkRow: View {
    let landmark: Landmark
    var body: some View {
        landmark.image
            .resizable()
            .frame(width: 50, height: 50) // Makes it look pretty so don't test
        Text(landmark.name)
        Spacer() // Again more UI pretty-ness no testing needed
        if landmark.isFavorite {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow) // UI so don't test
        }
    }
}
