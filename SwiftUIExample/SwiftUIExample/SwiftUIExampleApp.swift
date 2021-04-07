//
//  SwiftUIExampleApp.swift
//  SwiftUIExample
//
//  Created by thompsty on 1/19/21.
//

import SwiftUI
import Swinject
import Combine

@main
struct SwiftUIExampleApp: App {
    @StateObject private var appModel = AppModel()

    init() {
        ContainerRegistration.registerAllDependenciesIn(container: Container.default)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
        }
    }
}
