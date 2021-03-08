//
//  SwiftUIExampleApp.swift
//  SwiftUIExample
//
//  Created by thompsty on 1/19/21.
//

import SwiftUI

@main
struct SwiftUIExampleApp: App {
    @StateObject private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
        }
    }
}
