//
//  DependencyInjectionTests.swift
//  WriteToUserDefaultsTests
//
//  Created by thompsty on 1/15/21.
//

import Foundation
import XCTest
import Swinject

@testable import WriteToUserDefaults

class DependencyInjectionTests: XCTestCase {
    static var customContainer: Container!
    static var customName: String = "name1"

    override func setUpWithError() throws {
        Self.customContainer = Container()
        Container.default.removeAll()
    }

    func testDependenciesAreSetupCorrectly_OnAppLaunch() {
        let delegate = UIApplication.shared.delegate
        let actualDidFinishLaunching = delegate?.application?(UIApplication.shared, didFinishLaunchingWithOptions: [:])

        XCTAssertNotNil(delegate)
        XCTAssertEqual(actualDidFinishLaunching, true, "expected didFinishLaunching to return true")
        XCTAssert(Container.default.resolve(UserDefaults.self) === UserDefaults.standard, "expected dependency injection to resolve to UserDefaults.standard")
    }

    func testDefaultContainerAlwaysReturnsTheSameContainer() {
        let c1 = Container.default
        let c2 = Container.default

        XCTAssert(c1 === c2, "c1 and c2 are not the same instance")
    }

    func testPropertyWrapperGrabsFromDefaultContainer_IfNoContainerIsSpecified() {
        let expectedName = UUID().uuidString
        Container.default.register(String.self) { _ in expectedName }
        class SomeClass {
            @DependencyInjected var name: String?
        }
        struct SomeStruct {
            @DependencyInjected var name: String?
        }

        XCTAssertEqual(SomeClass().name, expectedName)
        var s = SomeStruct() // NOTE: Need a mutable reference since a DependencyInjected var is lazy
        XCTAssertEqual(s.name, expectedName)
    }

    func testPropertyWrapperGrabsByNameFromDefaultContainer_IfNameIsSpecifiedButContainerIsNot() {
        let junkName = UUID().uuidString
        let expectedName = UUID().uuidString
        Container.default.register(String.self) { _ in junkName }
        Container.default.register(String.self, name: "ResolveTHIS") { _ in expectedName }
        class SomeClass {
            @DependencyInjected(name: "ResolveTHIS") var name: String?
        }
        struct SomeStruct {
            @DependencyInjected(name: "ResolveTHIS") var name: String?
        }

        XCTAssertEqual(SomeClass().name, expectedName)
        var s = SomeStruct() // NOTE: Need a mutable reference since a DependencyInjected var is lazy
        XCTAssertEqual(s.name, expectedName)
    }

    func testPropertyWrapperGrabsFromSpecifiedContainer() {
        let junkName = UUID().uuidString
        let expectedName = UUID().uuidString
        Container.default.register(String.self) { _ in junkName }
        Self.customContainer.register(String.self) { _ in expectedName }
        class SomeClass {
            @DependencyInjected(container: DependencyInjectionTests.customContainer) var name: String?
        }
        struct SomeStruct {
            @DependencyInjected(container: DependencyInjectionTests.customContainer) var name: String?
        }

        XCTAssertEqual(SomeClass().name, expectedName)
        var s = SomeStruct() // NOTE: Need a mutable reference since a DependencyInjected var is lazy
        XCTAssertEqual(s.name, expectedName)
    }

    func testPropertyWrapperGrabsFromSpecifiedContainerWithSpecifiedName() {
        let junkName = UUID().uuidString
        let expectedName = UUID().uuidString
        Self.customContainer.register(String.self) { _ in junkName }
        Self.customContainer.register(String.self, name: "resolve") { _ in expectedName }
        class SomeClass {
            @DependencyInjected(container: DependencyInjectionTests.customContainer, name: "resolve") var name: String?
        }
        struct SomeStruct {
            @DependencyInjected(container: DependencyInjectionTests.customContainer, name: "resolve") var name: String?
        }

        XCTAssertEqual(SomeClass().name, expectedName)
        var s = SomeStruct() // NOTE: Need a mutable reference since a DependencyInjected var is lazy
        XCTAssertEqual(s.name, expectedName)
    }

    func testPropertyWrapperIsLazyLoaded() {
        class FakeReferenceClass { }
        Self.customContainer.register(FakeReferenceClass.self, name: "resolve") { _ in FakeReferenceClass() }
        class SomeClass {
            @DependencyInjected(container: DependencyInjectionTests.customContainer, name: "resolve") var name: FakeReferenceClass?
        }
        struct SomeStruct {
            @DependencyInjected(container: DependencyInjectionTests.customContainer, name: "resolve") var name: FakeReferenceClass?
        }
        let someClass = SomeClass()
        XCTAssert(someClass.name === someClass.name, "Expected name to be the same instance each time accessed")
        var s = SomeStruct() // NOTE: Need a mutable reference since a DependencyInjected var is lazy
        XCTAssert(s.name === s.name, "Expected name to be the same instance each time accessed")
    }

    func testPropertyWrapperInitsWithAutoClosures() {
        let expectedName = UUID().uuidString
        Self.customContainer.register(String.self, name: DependencyInjectionTests.customName) { _ in expectedName }
        class SomeClass {
            @DependencyInjected(container: DependencyInjectionTests.customContainer, name: DependencyInjectionTests.customName) var name: String?
        }
        struct SomeStruct {
            @DependencyInjected(container: DependencyInjectionTests.customContainer, name: DependencyInjectionTests.customName) var name: String?
        }
        let someClass = SomeClass()
        var s = SomeStruct()
        Self.customName = "name2"
        Self.customContainer = Container()
        let anotherExpectedName = UUID().uuidString
        Self.customContainer.register(String.self, name: DependencyInjectionTests.customName) { _ in anotherExpectedName }

        XCTAssertEqual(someClass.name, anotherExpectedName)
        XCTAssertEqual(s.name, anotherExpectedName)
    }
}
