//
//  SwiftUIExampleApp.swift
//  SwiftUIExample
//
//  Created by thompsty on 1/19/21.
//

import SwiftUI

@main
struct SwiftUIExampleApp: App {
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            CategoryHome().environmentObject(modelData)
        }
    }
}
