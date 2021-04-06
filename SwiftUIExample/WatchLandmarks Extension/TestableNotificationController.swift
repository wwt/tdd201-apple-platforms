//
//  TestableNotificationController.swift
//  WatchLandmarks Extension
//
//  Created by Richard Gist on 4/6/21.
//

import UserNotifications

protocol Notificationy {
    var body: NotificationView { get }
    func didReceive(_ notification: UNNotification)
}

class TestableNotificationController : Notificationy {
    var body: NotificationView {
        NotificationView(title: nil, message: nil, landmarkId: nil, landmarkImage: nil)
    }

    func didReceive(_ notification: UNNotification) {
        // nothing yet
    }
}
