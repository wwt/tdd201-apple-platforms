//
//  NotesListViewController.swift
//  UIKitWithStoryboardTests
//
//  Created by thompsty on 1/4/21.
//

import XCTest
import UIUTest
import Swinject
import Cuckoo

@testable import UIKitWithStoryboard

class NotesListViewControllerTests: XCTestCase {
    var viewController: NotesListViewController!

    override func setUpWithError() throws {
        Container.default.removeAll()
        viewController = UIViewController.loadFromStoryboard(identifier: "NotesListViewController", forNavigation: true)
        XCTAssertNotNil(viewController, "Expected to load NotesListViewController from storyboard")
    }

    func testViewControllerHasCorrectTitle() throws {
        XCTAssertEqual(viewController.title, "Notes")
    }

    func testViewControllerHasATitleLabel() throws {
        let titleLabel = viewController.view?.viewWithAccessibilityIdentifier("TitleLabel") as? UILabel

        XCTAssertNotNil(titleLabel, "Title Label should exist on view")
        XCTAssertEqual(titleLabel?.text, "Notes")
    }

    func testTableViewContainsNotes() throws {
        let mockNotesService = MockNotesService()
        let expectedNotes = [Note(name: "note1", contents: UUID().uuidString),
                             Note(name: "note2", contents: UUID().uuidString)]
        stub(mockNotesService) { (stub) in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
        }
        viewController = UIViewController.loadFromStoryboard(identifier: "NotesListViewController") { _ in
            Container.default.register(NotesService.self) { _ in mockNotesService }
        }
        let tableView: UITableView? = viewController.view?.viewWithAccessibilityIdentifier("NotesTableView") as? UITableView

        XCTAssertNotNil(tableView, "Expected to get a tableview from the view controller")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), expectedNotes.count)
        XCTAssertEqual(tableView?.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text, expectedNotes.first?.name)
        XCTAssertEqual(tableView?.cellForRow(at: IndexPath(row: 1, section: 0))?.textLabel?.text, expectedNotes.last?.name)
    }

    func testSelectNoteGoesToDetails() throws {
        let mockNotesService = MockNotesService()
        let expectedNote = Note(name: "note1", contents: UUID().uuidString)
        let expectedNotes = [expectedNote,
                             Note(name: "note2", contents: UUID().uuidString)]
        stub(mockNotesService) { (stub) in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
        }
        viewController = UIViewController.loadFromStoryboard(identifier: "NotesListViewController", forNavigation: true) { _ in
            Container.default.register(NotesService.self) { _ in mockNotesService }
        }
        let index = IndexPath(row: 0, section: 0)
        let mockTableView = objcStub(for: UITableView.self) { (stubber, mock) in
            stubber.when(mock.deselectRow(at: index, animated: true)).thenDoNothing()
        }
        let tableView: UITableView? = viewController.view?.viewWithAccessibilityIdentifier("NotesTableView") as? UITableView

        tableView?.delegate?.tableView?(mockTableView, didSelectRowAt: index)

        RunLoop.current.singlePass()

        let topVC: NoteDetailViewController? = viewController.navigationController?.topViewController as? NoteDetailViewController
        XCTAssertNotNil(topVC, "Expected top view controller to be NoteDetailViewController")
        XCTAssertEqual(topVC?.note?.name, expectedNote.name)
        XCTAssertEqual(topVC?.note?.contents, expectedNote.contents)

        objcVerify(mockTableView.deselectRow(at: index, animated: true))
    }
}
