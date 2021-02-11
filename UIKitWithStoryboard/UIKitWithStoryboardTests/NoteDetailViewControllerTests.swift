//
//  NoteDetailViewControllerTests.swift
//  UIKitWithStoryboardTests
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation
import XCTest
import Swinject
import UIUTest

@testable import UIKitWithStoryboard

class NoteDetailViewControllerTests: XCTestCase {
    var viewController: NoteDetailViewController!

    override func setUpWithError() throws {
        Container.default.removeAll()
        viewController = UIViewController.loadFromStoryboard(identifier: "NoteDetailViewController")
        XCTAssertNotNil(viewController, "Expected to load NoteDetailViewController from storyboard")
    }

    func testNoteDetailsAreDisplayed() throws {

    }

}
