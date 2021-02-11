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

    func testNoteNameIsDisplayed() throws {
        let note = Note(name: "Note 1", contents: UUID().uuidString)
        viewController = UIViewController.loadFromStoryboard(identifier: "NoteDetailViewController") { initialViewController in
            initialViewController.note = note
        }

        let noteNameLabel: UILabel? = viewController.view?.viewWithAccessibilityIdentifier("NameLabel") as? UILabel

        XCTAssertNotNil(viewController.note)
        XCTAssertEqual(noteNameLabel?.text, note.name)
    }

    func testNoteContentsAreDisplayed() throws {
        let note = Note(name: "Note 1", contents: UUID().uuidString)
        viewController = UIViewController.loadFromStoryboard(identifier: "NoteDetailViewController") { initialViewController in
            initialViewController.note = note
        }

        let textView: UITextView? = viewController.view?.viewWithAccessibilityIdentifier("ContentsTextView") as? UITextView

        XCTAssertNotNil(viewController.note)
        XCTAssertEqual(textView?.text, note.contents)
    }

}
