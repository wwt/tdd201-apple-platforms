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
    var testViewController: UIViewController!

    override func setUpWithError() throws {
        UIView.setAnimationsEnabled(false)
        UIViewController.initializeTestable()
        Container.default.removeAll()
        testViewController = UIViewController.loadFromStoryboard(identifier: "ViewController")
        XCTAssertNotNil(testViewController)
    }

    override func tearDownWithError() throws {
        UIView.setAnimationsEnabled(false)
        UIViewController.flushPendingTestArtifacts()
        UIViewController().loadForTesting()
    }

    func testFetchingProfileFromAPI() throws {
    }
}
