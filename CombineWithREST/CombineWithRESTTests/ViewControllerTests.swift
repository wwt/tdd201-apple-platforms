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

@testable import CombineWithREST

class ViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
        Container.default.removeAll()
    }

    func testFetchingProfileFromAPI() throws {
        let mock = MockIdentityServiceProtocol()
            .registerIn(container: Container.default)
        let expectedProfile = try User.Profile.createForTests()
        stub(mock) { stub in
            _ = when(stub.fetchProfile.get
                        .thenReturn(Result.Publisher(.success(expectedProfile)).eraseToAnyPublisher()))
        }
        let testViewController = ViewController()

        testViewController.fetchProfile()

        verify(mock, times(1)).fetchProfile.get()
        XCTAssertEqual(testViewController.fakeNameLabel, [expectedProfile.firstName, expectedProfile.lastName].compactMap { $0 }.joined(separator: " "))
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
        let testViewController = ViewController()

        testViewController.fetchProfile()

        verify(mock, times(1)).fetchProfile.get()
        XCTAssertEqual(testViewController.fakeErrorLabel, err.localizedDescription)
    }
}
