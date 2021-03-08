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

    func testWhenTappingFavoritesOnlyToggleOnLandmarksDetail_ImageChanges() throws {
        XCTAssert(FeaturedScreen.isVisible)
        MainScreen.navigateToLandmarksList()
        let detail = LandmarksScreen.goToLandmark(.turtleRock)
        XCTAssert(detail.isFavorite)
        XCTAssertFalse(detail.toggleFavorite().isFavorite)
        XCTAssert(detail.toggleFavorite().isFavorite)
    }

    func testWhenTappingLandmarkFromLandmarksList_UserGoesToLandmarkDetail() throws {
        XCTAssert(FeaturedScreen.isVisible)
        MainScreen.navigateToLandmarksList()
        XCTAssert(LandmarksScreen.isVisible)
        let detail = LandmarksScreen.goToLandmark(.silverSalmonCreek)
        XCTAssert(detail.isVisible)
        XCTAssert(detail.hasMap)
    }

    func testWhenTappingFavoritesOnlyToggleOnLandmarksList_ListOnlyShowsFavorites() throws {
        XCTAssert(FeaturedScreen.isVisible)
        MainScreen.navigateToLandmarksList()
        XCTAssertFalse(LandmarksScreen.isFavoritesOnly)
        let count = LandmarksScreen.landmarksInList
        XCTAssert(LandmarksScreen
                    .toggleFavorites()
                    .isFavoritesOnly)
        #warning("Too much testing? Since this is covered by unit test?")
        XCTAssertLessThan(LandmarksScreen.landmarksInList, count)
    }

    func testWhenTappingProfileToolbarButton_UserGoesToProfile() throws {
        XCTAssert(FeaturedScreen.isVisible)
        FeaturedScreen.goToProfile()
        XCTAssert(ProfileScreen.isVisible)
        XCTAssert(ProfileScreen.goalDateFormatted)
    }

    func testWhenTappingRecentHikesArror_HikeGraphElevationIsVisible() throws {
        XCTAssert(FeaturedScreen.isVisible)
        FeaturedScreen.goToProfile()
        ProfileScreen.toggleHikeGraph()
        XCTAssert(ProfileScreen.elevationGraphVisible)

//        let app = XCUIApplication()
//        app.navigationBars["Featured"].buttons["account"].tap()
//
//        let elementsQuery = app.scrollViews.otherElements
//        let chevronRightCircleButton = elementsQuery.buttons["chevron.right.circle"]
//        chevronRightCircleButton.tap()
//
//        let heartRateButton = elementsQuery.buttons["Heart Rate"]
//        heartRateButton.tap()
//
//        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 0)
//        element.tap()
//
//        let elevationButton = elementsQuery.buttons["Elevation"]
//        elevationButton.tap()
//        element.tap()
//        heartRateButton.tap()
//
//        let paceButton = elementsQuery.buttons["Pace"]
//        paceButton.tap()
//        paceButton.tap()
//        elevationButton.tap()
//
//        let verticalScrollBar1PageScrollView = elementsQuery/*@START_MENU_TOKEN@*/.scrollViews.containing(.other, identifier:"Vertical scroll bar, 1 page").element/*[[".scrollViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\").element",".scrollViews.containing(.other, identifier:\"Vertical scroll bar, 1 page\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        verticalScrollBar1PageScrollView.tap()
//        verticalScrollBar1PageScrollView.tap()
//        paceButton.tap()
//        verticalScrollBar1PageScrollView.tap()
//        verticalScrollBar1PageScrollView.tap()
//        element.tap()
//        element.tap()
//        verticalScrollBar1PageScrollView.tap()
//        verticalScrollBar1PageScrollView.tap()
//        element.tap()
//        elementsQuery.staticTexts["Lonesome Ridge Trail"].tap()
//        paceButton.tap()
//        paceButton.tap()
//        heartRateButton.tap()
//        chevronRightCircleButton.tap()

//        let app = XCUIApplication()
//        let elementsQuery = app.scrollViews.otherElements
//        let chevronRightCircleButton = elementsQuery.buttons["chevron.right.circle"]
//        chevronRightCircleButton.tap()
//        elementsQuery.buttons["Elevation"].tap()
//
//        let heartRateButton = elementsQuery.buttons["Heart Rate"]
//        heartRateButton.tap()
//        chevronRightCircleButton.tap()
//        chevronRightCircleButton.tap()
//
//        let paceButton = elementsQuery.buttons["Pace"]
//        paceButton.tap()
//        heartRateButton.tap()
//
//        let verticalScrollBar1PageScrollView = elementsQuery/*@START_MENU_TOKEN@*/.scrollViews.containing(.other, identifier:"Vertical scroll bar, 1 page").element/*[[".scrollViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\").element",".scrollViews.containing(.other, identifier:\"Vertical scroll bar, 1 page\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        verticalScrollBar1PageScrollView.tap()
//        paceButton.tap()
//        verticalScrollBar1PageScrollView.tap()
//        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0).tap()
//        verticalScrollBar1PageScrollView.tap()
//        verticalScrollBar1PageScrollView.tap()

//        let chevronRightCircleButton = XCUIApplication().scrollViews.otherElements.buttons["chevron.right.circle"]
//        chevronRightCircleButton.tap()
//        chevronRightCircleButton.tap()
//

    }

    func testWhenTappingProfileEdit_UserGoesToEditProfile() throws {
        XCTAssert(FeaturedScreen.isVisible)
        FeaturedScreen.goToProfile().goToEditProfile()
        XCTAssert(ProfileEditScreen.isVisible)
    }

    #warning("Switch is hittable but somehow tap() does not do anything :( ")
    func testWhenEditingProfile_UserCanChangeEnableNotificationSettings() throws {
        XCTAssert(FeaturedScreen.isVisible)
        FeaturedScreen.goToProfile().goToEditProfile()
        XCTAssert(ProfileEditScreen.notificationsEnabled)
//        XCTAssertFalse(ProfileEditScreen
//                        .toggleNotifications()
//                        .notificationsEnabled)
    }
    
    func testWhenEditingProfile_UserCanChangeUsername() throws {
        XCTAssert(FeaturedScreen.isVisible)
        FeaturedScreen.goToProfile().goToEditProfile()
        XCTAssert(ProfileEditScreen
                    .changeUsername(to: "heather")
                    .usernameMatches("heather"))
    }
    
    func testWhenEditingProfile_UserCanChangeSeasonalPhoto() throws {
        XCTAssert(FeaturedScreen.isVisible)
        FeaturedScreen.goToProfile().goToEditProfile()
        XCTAssert(ProfileEditScreen.seasonalPhotoMatches(.winter))
        XCTAssert(ProfileEditScreen
                    .changeSeasonalPhoto(to: .spring)
                    .seasonalPhotoMatches(.spring))
    }

    func testWhenEditingProfile_UserCanChangeGoalDate() throws {
        XCTAssert(FeaturedScreen.isVisible)
        FeaturedScreen.goToProfile().goToEditProfile()
        let newDate = Calendar(identifier: .gregorian).date(byAdding: .day, value: 3, to: Date())
        XCTAssert(ProfileEditScreen
                    .changeGoalDate(to: newDate)
                    .goalDateMatches(newDate))
    }

    func testWhenEditingProfile_UserTapsCancel_DataIsNotChangedOnSummary() throws {
        XCTAssert(FeaturedScreen.isVisible)
        FeaturedScreen
            .goToProfile()
            .goToEditProfile()
            .changeUsername(to: "heather")
            .cancelEditing()
        XCTAssert(ProfileScreen.isVisible)
        XCTAssertFalse(ProfileScreen.usernameMatches("heather"))
    }

    func testWhenEditingProfile_UserTapsDone_DataIsChangedOnSummary() throws {
        XCTAssert(FeaturedScreen.isVisible)
        FeaturedScreen
            .goToProfile()
            .goToEditProfile()
            .changeUsername(to: "heather")
            .finishEditing()
        XCTAssert(ProfileScreen.isVisible)
        XCTAssert(ProfileScreen.usernameMatches("heather"))
    }
}
