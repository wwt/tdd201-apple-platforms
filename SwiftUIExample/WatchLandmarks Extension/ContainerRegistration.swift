//
//  ContainerRegistration.swift
//  WatchLandmarks Extension
//
//  Created by thompsty on 4/7/21.
//

import Foundation
import Swinject

enum ContainerRegistration {
    static func registerAllDependenciesIn(container: Container) {
        Container.default.register(HikesServiceProtocol.self) { _ in API.HikesService() }
        Container.default.register(NotificationRespondable.self) { _ in TestableNotificationController() }
    }
}
