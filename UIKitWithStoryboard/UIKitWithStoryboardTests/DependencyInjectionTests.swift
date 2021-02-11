//
//  DependencyInjectionTests.swift
//  UIKitWithStoryboardTests
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation
import XCTest
import Swinject

@testable import UIKitWithStoryboard

class DependencyInjectionTests: XCTestCase {
    static var customContainer: Container!

    override func setUpWithError() throws {
        Self.customContainer = Container()
        Container.default.removeAll()
    }

    func testAppSetsUpCorrectDependenciesAtLaunch() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let didFinishLaunching = delegate?.application(UIApplication.shared, didFinishLaunchingWithOptions: [:])
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let notesURL = paths.first!.appendingPathComponent("notes")

        XCTAssertNotNil(delegate, "Test invalid, app delegate nil")
        XCTAssertEqual(didFinishLaunching, true, "Expected didFinishLaunching to be true")
        XCTAssertNotNil(Container.default.resolve(FileManager.DirectoryEnumerator.self, name: notesURL.absoluteString))
        XCTAssertNotNil(Container.default.resolve(Result<String, Error>.self, name: "ReadFromFile", arguments: notesURL, String.Encoding.utf8))
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

}
