//
//  ViewControllerTests.swift
//  WriteToUserDefaultsTests
//
//  Created by thompsty on 1/15/21.
//

import Foundation
import XCTest
import Cuckoo
import Swinject

@testable import WriteToUserDefaults

class ViewControllerTests: XCTestCase {
    struct Keys {
        struct UserDefaults {
            static let accountBalance = "accountBalance"
        }
    }
    
    var controller: ViewController!
    
    override func setUpWithError() throws {
        controller = ViewController()
    }
    
    func testViewControllerReadsFromUserDefaults_OnViewDidLoad() {
        let mock = objcStub(for: UserDefaults.self) { (stubber, mock) in
            stubber.when(mock.integer(forKey: Keys.UserDefaults.accountBalance)).thenReturn(100)
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
        
        controller.saveBalance()
        
        objcVerify(mock.setValue(100, forKey: Keys.UserDefaults.accountBalance))
    }
}
