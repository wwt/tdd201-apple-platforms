//
//  watchOSExampleApp.swift
//  watchOSExample WatchKit Extension
//
//  Created by thompsty on 2/1/21.
//

import SwiftUI

@main
struct watchOSExampleApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
