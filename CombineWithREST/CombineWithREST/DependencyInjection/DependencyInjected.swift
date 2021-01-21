//
//  DependencyInjected.swift
//  CombineWithREST
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import Swinject

@propertyWrapper
struct DependencyInjected<Value> {
    let name:String?
    let container:Container
    
    public init(wrappedValue value: Value?) {
        name = nil
        container = Container.default
    }
    public init(wrappedValue value: Value? = nil, name:String) {
        self.name = name
        container = Container.default
    }
    
    public init(wrappedValue value: Value? = nil, container containerGetter:@autoclosure () -> Container, name:String? = nil) {
        self.name = name
        container = containerGetter()
    }
    
    public lazy var wrappedValue: Value? = {
        container.resolve(Value.self, name: name)
    }()
}
