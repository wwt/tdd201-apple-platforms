//
//  AppDelegate.swift
//  WriteToUserDefaults
//
//  Created by thompsty on 1/4/21.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupDependencyInjection()
        return true
    }

    private func setupDependencyInjection() {
        Container.default.register(UserDefaults.self) { _ in UserDefaults.standard }
    }

}
