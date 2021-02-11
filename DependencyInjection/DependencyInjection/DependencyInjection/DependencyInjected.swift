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
    let nameGetter: (() -> String?)
    let containerGetter: () -> Container

    public init(container: @escaping @autoclosure () -> Container = Container.default,
                name: @escaping @autoclosure (() -> String?) = nil) {
        self.nameGetter = name
        self.containerGetter = container
    }

    public lazy var wrappedValue: Value? = {
        containerGetter().resolve(Value.self, name: nameGetter())
    }()
}
