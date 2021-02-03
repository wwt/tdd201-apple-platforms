//
//  ViewControllerTests.swift
//  WriteToUserDefaultsTests
//
//  Created by thompsty on 1/30/21.
//

import Foundation
import XCTest
import Cuckoo
import Swinject

@testable import WriteToUserDefaults

private typealias Keys = ViewController.Keys

class ViewControllerTests: XCTestCase {
    var controller: ViewController!

    override func setUpWithError() throws {
        controller = ViewController()
        Container.default.removeAll()
    }

    func testUserDefaultKeys() {
        XCTAssertEqual(Keys.UserDefaults.accountBalance, "accountBalance")
    }

    func testAccountBalanceIsReadFromUserDefaults_OnViewDidLoad() {
        let mock = objcStub(for: UserDefaults.self) { (stubber, mock) in
            stubber.when(mock.integer(forKey: Keys.UserDefaults.accountBalance)).thenReturn(30)
        }
        Container.default.register(UserDefaults.self) { _ in mock }

        controller.viewDidLoad()

        objcVerify(mock.integer(forKey: Keys.UserDefaults.accountBalance))
    }

    func testViewControllerWritesToUserDefaults_OnButtonPress() {
        let mock = objcStub(for: UserDefaults.self) { (stubber, mock) in
            stubber.when(mock.setValue(objcAny(), forKey: objcAny())).thenDoNothing()
        }
        Container.default.register(UserDefaults.self) { _ in mock }

        controller.buttonPressed()

        objcVerify(mock.setValue(100, forKey: Keys.UserDefaults.accountBalance))
    }
}
