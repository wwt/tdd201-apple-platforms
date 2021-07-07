//
//  ProfileSummary.swift
//  SwiftUIExample
//
//  Created by david.roff on 5/25/21.
//

import SwiftUI

struct ProfileSummary: View {
    @EnvironmentObject var appModel: AppModel
    @Binding var hikes: [Hike]
    var profile: Profile
    internal let inspection = Inspection<Self>()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(profile.username)
                .font(.title)
                .bold()
            Text("Notifications: \(profile.prefersNotifications ? "On" : "Off")")
            Text("Seasonal Photos: \(profile.seasonalPhoto.rawValue)")
            Text("Goal Date: ") + Text(profile.goalDate, style: .date)

            Divider()

            VStack(alignment: .leading) {
                Text("Completed Badges")
                    .font(.headline)

                ScrollView(.horizontal) {
                    HStack {
                        HikeBadge(name: "First Hike")
                        HikeBadge(name: "Earth Day")
                            .hueRotation(Angle(degrees: 90))
                        HikeBadge(name: "Tenth Hike")
                            .grayscale(0.5)
                            .hueRotation(Angle(degrees: 45))
                    }
                    .padding(.bottom)
                }
            }

            Divider()

            VStack(alignment: .leading) {
                Text("Recent Hikes")
                    .font(.headline)
                if let hike = hikes.first {
                    HikeView(hike: hike)
                }
            }
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
        Spacer()
    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static let profile = Profile.default
    static let hikes = [Hike(id: 1,
                             name: "",
                             distance: 10,
                             difficulty: 1,
                             observations: [Hike.Observation(distanceFromStart: 10,
                                                             elevation: 10.0..<20.0,
                                                             pace: 10..<20,
                                                             heartRate: 100..<120)])]

    static var previews: some View {
        ProfileSummary(hikes: .constant(hikes), profile: profile)
            .environmentObject(AppModel())
    }
}
