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
import Fakery
import Cuckoo

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

    func testNoteContentsAreSavedWhenUserNavigatesBack() throws {
        let note = Note(name: "Note 1", contents: "")
        let expectedContents = Faker().lorem.paragraphs()
        let mock = MockNotesService()
        stub(mock) { (stub) in
            when(stub.save(note: any(Note.self))).thenDoNothing()
        }
        Container.default.register(NotesService.self) { _ in mock }
        viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "NoteDetailViewController") as NoteDetailViewController
        viewController.note = note
        let navController = UINavigationController(rootViewController: UIViewController())
        navController.loadForTesting()
        navController.pushViewController(viewController, animated: false)
        RunLoop.current.singlePass()
        let textView: UITextView? = viewController.view?.viewWithAccessibilityIdentifier("ContentsTextView") as? UITextView

        textView?.simulateTouch()
        textView?.simulateTyping(expectedContents)
        viewController.navigationController?.backButton?.simulateTouch()
        RunLoop.current.singlePass()

        let argumentCaptor = ArgumentCaptor<Note>()
        verify(mock, times(1)).save(note: argumentCaptor.capture())
        XCTAssertEqual(argumentCaptor.value?.name, note.name)
        XCTAssertEqual(argumentCaptor.value?.contents, expectedContents)
    }
}
