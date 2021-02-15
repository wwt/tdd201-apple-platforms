//
//  SomeClassTests.swift
//  MockingFrameworkTests
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation
import XCTest
import Cuckoo

@testable import MockingFramework

class SomeClassTests: XCTestCase {

    func testMockingReadOnlyProperty() throws {
        let mock = MockSomeClass()
        stub(mock) { (stub) in
            when(stub.readOnlyProperty.get).thenReturn("Not real")
        }

        XCTAssertEqual(mock.readOnlyProperty, "Not real")
        verify(mock, times(1)).readOnlyProperty.get() // This is the SPY!
    }

    func testCallingOriginalImplementation_ReadOnlyProperty() throws {
        let mock = MockSomeClass()
        stub(mock) { (stub) in
            when(stub.readOnlyProperty.get).thenCallRealImplementation()
        }

        XCTAssertEqual(mock.readOnlyProperty, "README")
        verify(mock, times(1)).readOnlyProperty.get() // This is the SPY!
    }

    func testPartialMock() throws {
        let mock = MockSomeClass()
        let original = SomeClass()
        stub(mock) { (stub) in
            when(stub.readOnlyProperty.get).thenReturn("Not real")
        }
        mock.enableDefaultImplementation(original)

        XCTAssertEqual(mock.readOnlyProperty, "Not real")
        XCTAssertEqual(mock.readWriteProperty, "Write over me")
        verify(mock, times(1)).readOnlyProperty.get() // This is the SPY!
        verify(mock, times(1)).readWriteProperty.get()
    }

    func testMockingReadWritePropertySetter_WithAnyArgument() throws {
        let mock = MockSomeClass()
        stub(mock) { (stub) in
            when(stub.readWriteProperty.set(anyString())).thenDoNothing()
        }

        mock.readWriteProperty = "whatever"

        verify(mock, times(1)).readWriteProperty.set("whatever")
    }

    func testSpy() throws {
        let mock = MockSomeClass().withEnabledSuperclassSpy()

        mock.readWriteProperty = "whatever"

        verify(mock, times(1)).readWriteProperty.set("whatever")
        XCTAssertEqual(mock.readWriteProperty, "whatever")
        XCTAssertEqual(mock.readOnlyProperty, "README")
    }

    func testMockingLazyProperty() throws {
        let mock = MockSomeClass()
        stub(mock) { (stub) in
            when(stub.lazy.get).thenReturn("so lazy")
        }

        XCTAssertEqual(mock.lazy, "so lazy")
        verify(mock, times(1)).lazy.get()
    }

    func testMockingMultipleReturns() throws {
        let mock = MockSomeClass()
        stub(mock) { (stub) in
            when(stub.readOnlyProperty.get).thenReturn("1").thenReturn("2").thenReturn("3")
            when(stub.readWriteProperty.get).thenReturn("4", "5", "6")
            when(stub.lazy.get).thenReturn("7", "8", "9")
        }

        XCTAssertEqual(mock.readOnlyProperty, "1")
        XCTAssertEqual(mock.readOnlyProperty, "2")
        XCTAssertEqual(mock.readOnlyProperty, "3")
        verify(mock, times(3)).readOnlyProperty.get()
        XCTAssertEqual(mock.readWriteProperty, "4")
        XCTAssertEqual(mock.readWriteProperty, "5")
        XCTAssertEqual(mock.readWriteProperty, "6")
        verify(mock, times(3)).readWriteProperty.get()
        XCTAssertEqual(mock.lazy, "7") // This is bad.... but we can de-lazy the lazy
        XCTAssertEqual(mock.lazy, "8")
        XCTAssertEqual(mock.lazy, "9")
        verify(mock, times(3)).lazy.get()
    }

    func testMockingVoidMethod() throws {
        let mock = MockSomeClass()
        stub(mock) { (stub) in
            when(stub.voidMethod()).thenDoNothing()
        }

        mock.voidMethod()

        verify(mock, times(1)).voidMethod()
    }

    func testMockingVoidMethod_WithBody() throws {
        let mock = MockSomeClass()
        stub(mock) { (stub) in
            when(stub.voidMethod()).then { _ in
                XCTAssert(true)
            }
        }

        mock.voidMethod()

        verify(mock, times(1)).voidMethod()
    }

    func testMockingGenericVoid() throws {
        class Object: Matchable {
            var matcher = ParameterMatcher<Object>()
        }
        let mock = MockSomeClass()
        stub(mock) { (stub) in
            when(stub.genericVoid(param: any(Object.self))).thenDoNothing()
        }
        let object = Object()
        mock.genericVoid(param: object)

        verify(mock, times(1)).genericVoid(param: object)
    }

    func testMockingGenericVoid_WithSpecificParameter() throws {
        let mock = MockSomeClass()
        stub(mock) { (stub) in
            when(stub.genericVoid(param: "string")).thenDoNothing()
        }
        mock.genericVoid(param: "string")
//        mock.genericVoid(param: "different string")

        verify(mock, times(1)).genericVoid(param: "string")
    }

    func testMockingGenericVoic_WithNonEquatableParameter() throws {
        struct FakeStruct {
            let name: String
        }
        let mock = MockSomeClass()
        stub(mock) { (stub) in
            when(stub.genericVoid(param: any(FakeStruct.self))).thenDoNothing()
        }
        let expectedStruct = FakeStruct(name: UUID().uuidString)
        mock.genericVoid(param: expectedStruct)

        let argumentCaptor = ArgumentCaptor<FakeStruct>()
        verify(mock, times(1)).genericVoid(param: argumentCaptor.capture())
        XCTAssertEqual(argumentCaptor.value?.name, expectedStruct.name)
    }

    func testMockingGenericReturn() throws {
        let mock = MockSomeClass()
        stub(mock) { (stub) in
            when(stub.genericReturn(param: anyString())).thenReturn("any string")
        }

        XCTAssertEqual(mock.genericReturn(param: "this is a different string"), "any string")
        verify(mock, times(1)).genericReturn(param: anyString())
    }

    func testMockingReturnsBoolean() throws {
        let mock = MockSomeClass()
        stub(mock) { (stub) in
            when(stub.returnsBoolean()).thenReturn(false).thenCallRealImplementation()
        }

        XCTAssertFalse(mock.returnsBoolean())
        XCTAssert(mock.returnsBoolean())
        verify(mock, times(2)).returnsBoolean()
    }
}
