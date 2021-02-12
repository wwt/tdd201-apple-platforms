//
//  AppDelegate.swift
//  UIKitWithStoryboard
//
//  Created by thompsty on 1/4/21.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupDependencies()
        return true
    }

    func setupDependencies() {
        Container.default.register(NotesService.self) { _ in NotesService() }
        Container.default.register(FileManager.self) { _ in FileManager.default }
        Container.default.register(Result<String, Error>.self, name: "ReadFromFile") { (_, url, encoding) in
            Result {
                try String(contentsOf: url, encoding: encoding)
            }
        }
    }
}
