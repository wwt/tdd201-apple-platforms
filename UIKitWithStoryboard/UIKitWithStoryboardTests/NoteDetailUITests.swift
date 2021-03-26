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

class NoteDetailUITests: XCTestCase, UIUStoryboardTestable {
    typealias ViewControllerUnderTest = NoteDetailViewController

    override func setUpWithError() throws {
        UIView.setAnimationsEnabled(false)

        Container.default.removeAll()
        UIViewController.flushPendingTestArtifacts()
        UIViewController().loadForTesting()
    }

    override func tearDownWithError() throws {
        Container.default.removeAll()
        UIViewController.flushPendingTestArtifacts()
        UIViewController().loadForTesting()

        UIView.setAnimationsEnabled(true)
    }

    func testNoteNameIsDisplayed() throws {
        let note = Note(name: "Note 1", contents: "")
        let viewController = UIViewController.loadFromStoryboard(identifier: storyboardIdentifier) {
            let initialViewController = $0 as? NoteDetailViewController
            initialViewController?.note = note
        }

        XCTAssertEqual(viewController?.noteNameLabel?.text, note.name)
    }

    func testNoteContentsAreDisplayed() throws {
        let expectedContent = Faker().lorem.paragraphs(amount: 3)
        let note = Note(name: "Note 1", contents: expectedContent)
        let viewController = UIViewController.loadFromStoryboard(identifier: storyboardIdentifier) {
            let initialViewController = $0 as? NoteDetailViewController
            initialViewController?.note = note
        }

        XCTAssertEqual(viewController?.contentsTextView?.text, note.contents)
    }

    func testNoteContentsAreSavedWhenUserNavigatesBack() throws {
        let note = Note(name: "Note 1", contents: "")
        let expectedContent = Faker().lorem.paragraphs()
        let mock = MockNotesService().stub { stub in
            when(stub.save(note: any(Note.self))).thenDoNothing()
        }.registerIn(Container.default)
        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: storyboardIdentifier)
        (viewController as? NoteDetailViewController)?.note = note
        let navController = UINavigationController(rootViewController: UIViewController())
        navController.loadForTesting()
        navController.pushViewController(viewController, animated: false)
        RunLoop.current.singlePass()
        let textView = viewController.contentsTextView

        textView?.simulateTouch()
        textView?.simulateTyping(expectedContent)
        viewController.navigationController?.backButton?.simulateTouch()
        RunLoop.current.singlePass()

        let argumentCaptor = ArgumentCaptor<Note>()
        verify(mock, times(1)).save(note: argumentCaptor.capture())
        XCTAssertEqual(argumentCaptor.value?.name, note.name)
        XCTAssertEqual(argumentCaptor.value?.contents, expectedContent)
    }
}

fileprivate extension UIViewController {
    var noteNameLabel: UILabel? { view?.viewWithAccessibilityIdentifier("NameLabel") as? UILabel }
    var contentsTextView: UITextView? { view?.viewWithAccessibilityIdentifier("ContentsTextView") as? UITextView }
}
