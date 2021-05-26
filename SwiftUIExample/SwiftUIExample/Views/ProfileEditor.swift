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
        VStack(alignment: .leading) {
            HStack {
                Text("Username")
                    .font(.headline)
                TextField("Username", text: $profile.username)
            }
            Toggle(isOn: $profile.prefersNotifications) {
                Text("Enable Notifications")
                    .font(.headline)
            }
            Text("Seasonal Photo")
                .font(.headline)
            Picker("Seasonal Photo", selection: $profile.seasonalPhoto) {
                ForEach(Profile.Season.allCases) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            DatePicker(selection: $profile.goalDate, displayedComponents: .date) {
                Text("Goal Date")
                    .font(.headline)
            }
            Spacer()
        }
        .padding()
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(profile: .constant(.default))
            .preferredColorScheme(.dark)
    }
}
