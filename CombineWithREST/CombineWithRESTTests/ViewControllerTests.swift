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
    func testFetchingProfileFromAPI() {
        let mock = MockIdentityServiceProtocol()
            .registerIn(container: Container.default)
        let expectedProfile = User.Profile.createForTests()
        stub(mock) { stub in
            _ = when(stub.fetchProfile.get
                        .thenReturn(Result.Publisher(.success(expectedProfile)).eraseToAnyPublisher()))
        }
        let testViewController = ViewController()

        testViewController.fetchProfile()

        verify(mock, times(1)).fetchProfile.get()
        XCTAssertEqual(testViewController.fakeNameLabel, [expectedProfile.firstName, expectedProfile.lastName].compactMap { $0 }.joined(separator: " "))
    }

    func testFetchingProfileDoesNotRetainAStrongReference() {
        let mock = MockIdentityServiceProtocol()
            .registerIn(container: Container.default)
        stub(mock) { stub in
            _ = when(stub.fetchProfile.get
                        .thenReturn(Result.Publisher(.success(User.Profile.createForTests()))
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

    func testFetchingProfileWhenThereIsAnError() {
        let err = API.IdentityService.FetchProfileError.apiBorked
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
