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

    public init(wrappedValue value: Value?) {
        name = nil
        container = Container.default
    }
    public init(name: String) {
        self.name = name
        container = Container.default
    }

    public init(container: Container, name: String? = nil) {
        self.name = name
        self.container = container
    }

    public lazy var wrappedValue: Value? = {
        container.resolve(Value.self, name: name)
    }()
}
