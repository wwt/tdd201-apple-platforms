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
    var setupDependencies = { }

    override func setUpWithError() throws {
        Container.default.removeAll()
        viewController = UIViewController.loadFromStoryboard(identifier: "NotesListViewController")
        XCTAssertNotNil(viewController, "Expected to load NotesListViewController from storyboard")
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

}
