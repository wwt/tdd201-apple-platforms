//
//  SwiftUIExampleUITests.swift
//  SwiftUIExampleUITests
//
//  Created by Heather Meadow on 2/25/21.
//

import XCTest

class SwiftUIExampleUITests: XCTestCase {

    override func setUpWithError() throws {
        XCUIApplication.current.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        XCUIApplication.current.terminate()
    }

    func testTabViewChangesViews() throws {
        XCTAssert(FeaturedScreen.isVisible)
        MainScreen.navigateToLandmarksList()
        XCTAssert(LandmarksScreen.isVisible)
        MainScreen.navigateToCategoryHome()
        XCTAssert(FeaturedScreen.isVisible)
    }

    func testWhenTappingLandmark_UserGoesToLandmarkDetail() throws {
        XCTAssert(FeaturedScreen.isVisible)
        XCTAssert(FeaturedScreen
                    .goToLandmark(.silverSalmonCreek)
                    .isVisible)
    }

    func testWhenTappingProfileToolbarButton_UserGoesToProfile() throws {
        XCTAssert(FeaturedScreen.isVisible)
        XCTAssert(FeaturedScreen
                    .goToProfile()
                    .isVisible)
    }


}
