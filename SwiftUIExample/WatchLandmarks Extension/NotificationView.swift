//
//  NotificationView.swift
//  WatchLandmarks Extension
//
//  Created by Richard Gist on 4/6/21.
//

import SwiftUI

struct NotificationView: View {
    let title: String?
    let message: String?
    let landmarkId: Int?
    let landmarkImage: Image?

    var body: some View {
        VStack {
            if let image = landmarkImage {
                CircleImage(image: image.resizable()).scaledToFit()
            }

            Text(title ?? "Unknown Landmark")
                .font(.headline)
            Text(message ?? "You are within 5 miles of one of your favorite landmarks.")
                .font(.caption)
        }
    }
}
