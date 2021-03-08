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
        XCTAssertLessThan(LandmarksScreen.landmarksInList, count)
    }

    func testWhenTappingProfileToolbarButton_UserGoesToProfile() throws {
        XCTAssert(FeaturedScreen.isVisible)
        FeaturedScreen.goToProfile()
        XCTAssert(ProfileScreen.isVisible)
        XCTAssert(ProfileScreen.goalDateFormatted)
    }

    func testWhenTappingRecentHikesArror_HikeGraphIsVisible() throws {
        XCTAssert(FeaturedScreen.isVisible)
        FeaturedScreen.goToProfile()
        ProfileScreen.toggleHikeGraph()
        XCTAssert(ProfileScreen.elevationGraphHittable)
        XCTAssert(ProfileScreen.paceGraphHittable)
        XCTAssert(ProfileScreen.heartRateGraphHittable)
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
