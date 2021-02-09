//
//  DependencyInjected.swift
//  DependencyInjection
//
//  Created by thompsty on 1/30/21.
//

import Foundation
import Swinject

@propertyWrapper
struct DependencyInjected<Value> {
    let name: String?
    let container: Container

    public init(container: Container = Container.default, name: String? = nil) {
        self.name = name
        self.container = container
    }

    public lazy var wrappedValue: Value? = {
        container.resolve(Value.self, name: name)
    }()
}
