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
        let note = Note(name: "Note 1", contents: UUID().uuidString)
        let viewController = UIViewController.loadFromStoryboard(identifier: Identifier.storyboard) {
            let initialViewController = $0 as? NoteDetailViewController
            initialViewController?.note = note
        }

        XCTAssertEqual(viewController?.noteNameLabel?.text, note.name)
    }

    func testNoteContentsAreDisplayed() throws {
        let note = Note(name: "Note 1", contents: UUID().uuidString)
        let viewController = UIViewController.loadFromStoryboard(identifier: Identifier.storyboard) { let initialViewController = $0 as? NoteDetailViewController
            initialViewController?.note = note
        }

        XCTAssertEqual(viewController?.contentsTextView?.text, note.contents)
    }

    func testNoteContentsAreSavedWhenUserNavigatesBack() throws {
        let note = Note(name: "Note 1", contents: "")
        let expectedContents = Faker().lorem.paragraphs()
        let mock = MockNotesService()
        stub(mock) { (stub) in
            when(stub.save(note: any(Note.self))).thenDoNothing()
        }
        Container.default.register(NotesService.self) { _ in mock }
        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: Identifier.storyboard)
        (viewController as? NoteDetailViewController)?.note = note
        let navController = UINavigationController(rootViewController: UIViewController())
        navController.loadForTesting()
        navController.pushViewController(viewController, animated: false)
        RunLoop.current.singlePass()
        let textView = viewController.contentsTextView

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

extension NoteDetailViewControllerTests {
    enum Identifier {
        static let storyboard = "NoteDetailViewController"
    }
}

fileprivate extension UIViewController {
    var noteNameLabel: UILabel? { view?.viewWithAccessibilityIdentifier("NameLabel") as? UILabel }
    var contentsTextView: UITextView? { view?.viewWithAccessibilityIdentifier("ContentsTextView") as? UITextView }
}
