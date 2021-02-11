//
//  NotesListViewController.swift
//  UIKitWithStoryboardTests
//
//  Created by thompsty on 1/4/21.
//

import XCTest
import UIUTest

@testable import UIKitWithStoryboard

class NotesListViewControllerTests: XCTestCase {
    var viewController: NotesListViewController!

    override func setUpWithError() throws {
        viewController = UIViewController.loadFromStoryboard(identifier: "NotesListViewController") as? NotesListViewController
        XCTAssertNotNil(viewController, "Expected to load NotesListViewController from storyboard")
    }

    func testTableViewContainsNotes() throws {
        
    }

}
