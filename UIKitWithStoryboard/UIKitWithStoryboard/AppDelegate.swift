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
        Container.default.register(Result<FileReadable, Error>.self) { (_, url, encoding) in
            Result {
                try String(contentsOf: url, encoding: encoding)
            }
        }

        guard let notesURL = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask).first?
                .appendingPathComponent("notes"),
              let enumerator = FileManager.default
                .enumerator(at: notesURL, includingPropertiesForKeys: nil) else {
            return
        }
        Container.default.register(FileManager.DirectoryEnumerator.self,
                                   name: notesURL.absoluteString) { _ in enumerator }
    }
}
