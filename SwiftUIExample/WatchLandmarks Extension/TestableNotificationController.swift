//
//  TestableNotificationController.swift
//  WatchLandmarks Extension
//
//  Created by Richard Gist on 4/6/21.
//

import UserNotifications
import SwiftUI

protocol NotificationRespondable {
    var body: NotificationView { get }
    func didReceive(_ notification: UNNotification)
}

class TestableNotificationController: NotificationRespondable {
    var title: String?
    var message: String?
    var landmarkId: Int?
    var landmarkImage: Image?

    var body: NotificationView {
        NotificationView(title: title,
                         message: message,
                         landmarkId: landmarkId,
                         landmarkImage: landmarkImage)
    }

    func didReceive(_ notification: UNNotification) {
        let notificationContent = notification.request.content.userInfo as? [String: Any]
        let aps = notificationContent?["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: Any]
        title = alert?["title"] as? String
        message = alert?["body"] as? String
        landmarkId = notificationContent?["landmarkId"] as? Int
        if let imageName = notificationContent?["landmarkImage"] as? String {
            landmarkImage = Image(imageName)
        }
    }
}
