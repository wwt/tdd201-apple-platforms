//
//  FavoriteButton.swift
//  SwiftUIExample
//
//  Created by Richard Gist on 4/9/21.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool

    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Image(systemName: isSet ? "star.fill" : "star")
                .foregroundColor(isSet ? Color.yellow : Color.gray)
        }
    }
}
