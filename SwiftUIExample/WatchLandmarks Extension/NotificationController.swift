//
//  NotificationController.swift
//  WatchLandmarks Extension
//
//  Created by Richard Gist on 4/6/21.
//

import WatchKit
import SwiftUI
import UserNotifications

class NotificationController: WKUserNotificationHostingController<NotificationView> {
    @DependencyInjected var notificationResponder: NotificationRespondable!

    override var body: NotificationView {
        return notificationResponder.body
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification) {
        notificationResponder.didReceive(notification)
    }
}