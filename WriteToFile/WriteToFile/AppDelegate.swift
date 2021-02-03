//
//  AppDelegate.swift
//  WriteToFile
//
//  Created by thompsty on 1/4/21.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupDependencyInjection()
        return true
    }

    private func setupDependencyInjection() {
        Container.default.register(FileManager.self) { _ in FileManager.default }
    }
}
