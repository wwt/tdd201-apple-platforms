//
//  CategoryRow.swift
//  SwiftUIExample
//
//  Created by Zach Frew on 5/21/21.
//

import SwiftUI

struct CategoryRow: View {
    var name: String
    var items: [Landmark]

    var body: some View {
        Text("Hello, World!")
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(name: "", items: [])
    }
}
