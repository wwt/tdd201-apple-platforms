//
//  SomeStruct.swift
//  MockingFramework
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation

protocol SomeProtocol {
    var readOnlyProperty: String { get }
    var readWriteProperty: String { get set }
    var lazy: String { mutating get }
    func voidMethod()
    func returnsBoolean() -> Bool
    func genericVoid<T>(param: T)
    func genericReturn<T>(param: T) -> T
}

struct SomeStructWithProtocol: SomeProtocol {
    let readOnlyProperty: String
    var readWriteProperty: String
    var cantTouchThis: String
    lazy var lazy: String = { "I too am lazy" }()

    func voidMethod() {

    }

    func returnsBoolean() -> Bool {
        return true
    }

    func genericVoid<T>(param: T) {

    }

    func genericReturn<T>(param: T) -> T {
        return param
    }
}

struct SomeStruct {
    let readOnlyProperty: String
    var readWriteProperty: String
    var orCanYou: String
    var getOnlyProperty: String { "get me" }
    lazy var lazy: String = { "I am so lazy" }()

    func voidMethod() {

    }

    func returnsBoolean() -> Bool {
        return true
    }

    func genericVoid<T>(param: T) {

    }

    func genericReturn<T>(param: T) -> T {
        return param
    }
}
