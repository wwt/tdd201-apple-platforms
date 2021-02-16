//
//  ViewControllerTests.swift
//  CombineWithRESTTests
//
//  Created by thompsty on 1/21/21.
//

import Foundation
import XCTest
import Swinject
import Cuckoo
import Combine
import UIUTest

@testable import CombineWithREST

class ViewControllerTests: XCTestCase {
    var testViewController: ViewController!

    override func setUpWithError() throws {
        UIView.setAnimationsEnabled(false)
        UIViewController.initializeTestable()
        Container.default.removeAll()
        testViewController = UIViewController.loadFromStoryboard(identifier: "ViewController")
        XCTAssertNotNil(testViewController)
    }

    func testFetchingProfileFromAPI() throws {
        let mock = MockIdentityServiceProtocol()
            .registerIn(container: Container.default)
        let expectedProfile = try User.Profile.createForTests()
        stub(mock) { stub in
            _ = when(stub.fetchProfile.get
                        .thenReturn(Result.Publisher(.success(expectedProfile)).eraseToAnyPublisher()))
        }
        let nameLabel: UILabel? = testViewController.view.viewWithAccessibilityIdentifier("nameLabel") as? UILabel

        testViewController.fetchProfile()

        verify(mock, times(1)).fetchProfile.get()
        XCTAssertEqual(nameLabel?.text, [expectedProfile.firstName, expectedProfile.lastName].compactMap { $0 }.joined(separator: " "))
    }

    func testFetchingProfileDoesNotRetainAStrongReference() throws {
        let mock = MockIdentityServiceProtocol()
            .registerIn(container: Container.default)
        let profile = try User.Profile.createForTests()
        stub(mock) { stub in
            _ = when(stub.fetchProfile.get
                        .thenReturn(Result.Publisher(.success(profile))
                                        .delay(for: .seconds(10), scheduler: RunLoop.main)
                                        .eraseToAnyPublisher()))
        }
        var testViewController: ViewController? = ViewController()
        XCTAssertEqual(testViewController?.ongoingCalls.count, 0)
        weak var ref = testViewController

        testViewController?.fetchProfile()
        XCTAssertEqual(testViewController?.ongoingCalls.count, 1)
        testViewController = nil

        verify(mock, times(1)).fetchProfile.get()
        XCTAssertNil(ref)
    }

    func testFetchingProfileWhenThereIsAnError() throws {
        let err = API.IdentityService.FetchProfileError.apiBorked(API.AuthorizationError.unauthorized)
        let mock = MockIdentityServiceProtocol()
            .registerIn(container: Container.default)
        stub(mock) { stub in
            _ = when(stub.fetchProfile.get
                        .thenReturn(Result.Publisher(.failure(err))
                                        .eraseToAnyPublisher()))
        }

        testViewController.fetchProfile()
        RunLoop.current.singlePass()

        verify(mock, times(1)).fetchProfile.get()
        let alertVC = testViewController.presentedViewController as? UIAlertController
        XCTAssertNotNil(alertVC, "Expected \(String(describing: testViewController.presentedViewController)) to be UIAlertController")
        XCTAssertEqual(alertVC?.actions.count, 1)
        XCTAssertEqual(alertVC?.actions.first?.style, .default)
        XCTAssertEqual(alertVC?.actions.first?.title, "Ok")
        XCTAssertEqual(alertVC?.preferredStyle, .alert)
        XCTAssertEqual(alertVC?.title, "Something went wrong")
        XCTAssertEqual(alertVC?.message, err.localizedDescription)
    }
}
