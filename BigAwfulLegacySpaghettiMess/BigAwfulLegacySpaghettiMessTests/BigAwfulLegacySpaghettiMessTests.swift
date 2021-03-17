//
//  BigAwfulLegacySpaghettiMessTests.swift
//  BigAwfulLegacySpaghettiMessTests
//
//  Created by thompsty on 1/4/21.
//

import XCTest
@testable import BigAwfulLegacySpaghettiMess

class BigAwfulLegacySpaghettiMessTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        ViewController().viewDidLoad()
        ViewController().loadPasts()
        ViewController().didGetTapped()
        let expectation = self.expectation(description: "Self-fulfilling propehcy")
        currentEnvironment = .stage
        NetworkManager.getPastas {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 6)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
