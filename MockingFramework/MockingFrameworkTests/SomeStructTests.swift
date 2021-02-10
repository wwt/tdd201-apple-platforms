//
//  SomeStructTests.swift
//  MockingFrameworkTests
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation
import XCTest

@testable import MockingFramework

class SomeStructTests: XCTestCase {
    static var swizzledReturnsBooleanCallCount = 0
    static var swizzledGenericReturn = [Any]()

    override func setUpWithError() throws {
        Self.swizzledReturnsBooleanCallCount = 0
        Self.swizzledGenericReturn = []
    }

    func testYouCanTouchThis() throws {
        struct NewStruct {
            var stringProperty: String
            func returnsBoolean() -> Bool { false }
        }

        let s = SomeStruct()
        let cast = unsafeBitCast(s, to: NewStruct.self)

        XCTAssertEqual(cast.stringProperty, "touched") // No protection from this
        XCTAssertFalse(cast.returnsBoolean())
    }

    func testYouCanSwizzleThis() throws {
        XCTAssert(SomeStruct().returnsBoolean())
        XCTAssertEqual(Self.swizzledReturnsBooleanCallCount, 1)

        let string = "string"
        XCTAssertEqual(SomeStruct().genericReturn(param: string), string)
        XCTAssertEqual(Self.swizzledGenericReturn.count, 1)
        XCTAssertEqual(Self.swizzledGenericReturn.first as? String, string)
    }

}

fileprivate extension SomeStruct {
    @_dynamicReplacement(for: returnsBoolean)
    func _returnsBoolean() -> Bool {
        SomeStructTests.swizzledReturnsBooleanCallCount += 1
        return returnsBoolean()
    }

    @_dynamicReplacement(for: genericReturn(param:))
    func _genericReturn<T>(param: T) -> T {
        SomeStructTests.swizzledGenericReturn.append(param)
        return genericReturn(param: param)
    }
}
