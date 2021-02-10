//
//  SomeClass.swift
//  MockingFramework
//
//  Created by thompsty on 1/5/21.
//

import Foundation

class SomeSuperClass {
    var readOnlyProperty: String { "README" }
    var readWriteProperty: String = "Write over me"
    private var cantTouchThis: String = "no touchy"
    lazy var lazy: String = { "I too am lazy" }()

    func voidMethod() {

    }

    func genericVoid<T>(param: T) {

    }

    func genericReturn<T>(param: T) -> T {
        return param
    }

}

class SomeClass: SomeSuperClass {

    func returnsBoolean() -> Bool {
        return true
    }

    override func genericVoid<T>(param: T) {

    }
}
