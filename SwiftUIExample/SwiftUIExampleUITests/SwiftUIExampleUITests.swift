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

    func testWhenTappingLandmarkFromFeatured_UserGoesToLandmarkDetail() throws {
        XCTAssert(FeaturedScreen.isVisible)
        XCTAssert(FeaturedScreen
                    .goToLandmark(.silverSalmonCreek)
                    .isVisible)
    }

    func testWhenTappingProfileToolbarButton_UserGoesToProfile() throws {
        XCTAssert(FeaturedScreen.isVisible)
        let profile = FeaturedScreen.goToProfile()
        XCTAssert(profile.isVisible)
        XCTAssert(profile.goalDateFormatted)
    }

    func testWhenTappingLandmarkFromLandmarksList_UserGoesToLandmarkDetail() throws {
        XCTAssert(FeaturedScreen.isVisible)
        MainScreen.navigateToLandmarksList()
        XCTAssert(LandmarksScreen.isVisible)
        let detail = LandmarksScreen.goToLandmark(.silverSalmonCreek)
        XCTAssert(detail.isVisible)
        XCTAssert(detail.hasMap)
    }

    func testWhenTappingProfileEdit_UserGoesToEditProfile() throws {
        XCTAssert(FeaturedScreen.isVisible)
        let editProfile = FeaturedScreen.goToProfile().goToEditProfile()
        XCTAssert(editProfile.isVisible)
    }

    #warning("Switch is hittable but somehow tap() does not do anything :( ")
    func testWhenEditingProfile_UserCanChangeEnableNotificationSettings() throws {
        XCTAssert(FeaturedScreen.isVisible)
        let editProfile = FeaturedScreen.goToProfile().goToEditProfile()
        XCTAssert(editProfile.notificationsEnabled)
//        XCTAssertFalse(editProfile
//                        .toggleNotifications()
//                        .notificationsEnabled)
    }
    
    func testWhenEditingProfile_UserCanChangeUsername() throws {
        XCTAssert(FeaturedScreen.isVisible)
        let profile = FeaturedScreen.goToProfile()
        let editProfile = profile.goToEditProfile()
        XCTAssert(editProfile
                    .changeUsername(to: "heather")
                    .usernameMatches("heather"))
    }
    
    func testWhenEditingProfile_UserCanChangeSeasonalPhoto() throws {
        XCTAssert(FeaturedScreen.isVisible)
        let editProfile = FeaturedScreen.goToProfile().goToEditProfile()
        XCTAssert(editProfile.seasonalPhotoMatches(.winter))
        XCTAssert(editProfile
                    .changeSeasonalPhoto(to: .spring)
                    .seasonalPhotoMatches(.spring))
    }

    func testWhenEditingProfile_UserCanChangeGoalDate() throws {
        XCTAssert(FeaturedScreen.isVisible)
        let editProfile = FeaturedScreen.goToProfile().goToEditProfile()
        let newDate = Calendar(identifier: .gregorian).date(byAdding: .day, value: 3, to: Date())
        XCTAssert(editProfile.changeGoalDate(to: newDate).goalDateMatches(newDate))
    }

    func testWhenEditingProfile_UserTapsCancel_DataIsNotChangedOnSummary() throws {
        XCTAssert(FeaturedScreen.isVisible)
        let profile = FeaturedScreen
            .goToProfile()
            .goToEditProfile()
            .changeUsername(to: "heather")
            .cancelEditing()
        XCTAssert(profile.isVisible)
        XCTAssertFalse(profile.usernameMatches("heather"))
    }

    func testWhenEditingProfile_UserTapsDone_DataIsChangedOnSummary() throws {
        XCTAssert(FeaturedScreen.isVisible)
        let profile = FeaturedScreen
            .goToProfile()
            .goToEditProfile()
            .changeUsername(to: "heather")
            .finishEditing()
        XCTAssert(profile.isVisible)
        XCTAssert(profile.usernameMatches("heather"))
    }

    func testddddd() throws {
//
//        let app = app2
//        app.navigationBars["Featured"].buttons["account"].tap()
//        app.buttons["Edit"].tap()
//
//        let app2 = app
//        app2.tables/*@START_MENU_TOKEN@*/.datePickers.containing(.other, identifier:"Date Picker").element/*[[".cells[\"Goal Date, Date Picker, Mar 4, 2021\"].datePickers.containing(.other, identifier:\"Date Picker\").element",".datePickers.containing(.other, identifier:\"Date Picker\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app2/*@START_MENU_TOKEN@*/.datePickers/*[[".otherElements[\"Preview\"].datePickers",".datePickers"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.collectionViews.buttons["Wednesday, March 24"].otherElements.containing(.staticText, identifier:"24").element.tap()
//
////
//        let x = XCUIApplication.current.datePickers.firstMatch
//
//        let app = XCUIApplication()
//        app.navigationBars["Featured"].buttons["account"].tap()
//
//        let collectionViewsQuery = XCUIApplication()/*@START_MENU_TOKEN@*/.datePickers/*[[".otherElements[\"Preview\"].datePickers",".datePickers"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.collectionViews
//        collectionViewsQuery.buttons["Thursday, March 11"].otherElements.containing(.staticText, identifier:"11").element.tap()
//        collectionViewsQuery.buttons["Thursday, March 25"].otherElements.containing(.staticText, identifier:"25").element.tap()
//        app.buttons["Edit"].tap()

    }

}
