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
    let name: (() -> String?)
    let container: Container

    public init(container: Container = Container.default) {
        self.name = { nil }
        self.container = container
    }

    public init(container: Container = Container.default, name: @escaping @autoclosure (() -> String?)) {
        self.name = name
        self.container = container
    }

    public lazy var wrappedValue: Value? = {
        container.resolve(Value.self, name: name())
    }()
}
