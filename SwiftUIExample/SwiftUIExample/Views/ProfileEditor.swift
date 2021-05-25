//
//  ProfileEditor.swift
//  SwiftUIExample
//
//  Created by david.roff on 5/25/21.
//

import SwiftUI

struct ProfileEditor: View {
    @Binding var profile: Profile

    var body: some View {
        Text("Hello, World!")
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(profile: .constant(.default))
    }
}
