//
//  ProfileHost.swift
//  SwiftUIExample
//
//  Created by david.roff on 5/25/21.
//

import SwiftUI

struct ProfileHost: View {
    @Environment(\.editMode) private var editMode
    @EnvironmentObject private var appModel: AppModel
    @State private var draftProfile = Profile.default
    let inspection = Inspection<Self>()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel") {
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }
            if editMode?.wrappedValue == .active {
                ProfileEditor(profile: $draftProfile)
                    .onAppear {
                        draftProfile = appModel.profile
                    }
                    .onDisappear {
                        appModel.profile = draftProfile
                    }
            } else {
                ProfileSummary(hikes: $appModel.hikes, profile: draftProfile)
            }
        }
        .padding()
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }

    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost()
            .environmentObject(AppModel())
            .preferredColorScheme(.dark)
    }
}
