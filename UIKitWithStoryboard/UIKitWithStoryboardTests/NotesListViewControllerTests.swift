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

    func testViewControllerHasAnAddNoteButton() throws {
        let addButton = viewController.view?.viewWithAccessibilityIdentifier("AddNoteButton") as? UIButton
        XCTAssertNotNil(addButton)
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

    func testUserCanAddANote() throws {
        let mockNotesService = MockNotesService()
        let expectedNote = Note(name: "note1", contents: UUID().uuidString)
        let expectedNotes = [expectedNote,
                             Note(name: "note2", contents: UUID().uuidString)]
        stub(mockNotesService) { (stub) in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
            when(stub.save(note: any(Note.self))).thenDoNothing()
        }
        viewController = UIViewController.loadFromStoryboard(identifier: "NotesListViewController", forNavigation: true) { _ in
            Container.default.register(NotesService.self) { _ in mockNotesService }
        }

        let tableView: UITableView? = viewController.view?.viewWithAccessibilityIdentifier("NotesTableView") as? UITableView
        let addButton = viewController.view?.viewWithAccessibilityIdentifier("AddNoteButton") as? UIButton

        addButton?.simulateTouch()

        XCTAssertNotNil(addButton)
        let argumentCaptor = ArgumentCaptor<Note>()
        verify(mockNotesService, times(1)).save(note: argumentCaptor.capture())
        XCTAssertEqual(argumentCaptor.value?.name, "note3")
        XCTAssertEqual(argumentCaptor.value?.contents, "")

        XCTAssertNotNil(tableView, "Expected to get a tableview from the view controller")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), expectedNotes.count+1)
        XCTAssertEqual(tableView?.cellForRow(at: IndexPath(row: expectedNotes.count, section: 0))?.textLabel?.text, argumentCaptor.value?.name)
    }

    func testWhenUserAddsNote_TheNameIsUnique() throws {
        let mockNotesService = MockNotesService()
        let expectedNotes = [Note(name: "note2", contents: UUID().uuidString)]
        stub(mockNotesService) { (stub) in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
            when(stub.save(note: any(Note.self))).thenDoNothing()
        }
        viewController = UIViewController.loadFromStoryboard(identifier: "NotesListViewController", forNavigation: true) { _ in
            Container.default.register(NotesService.self) { _ in mockNotesService }
        }

        let addButton = viewController.view?.viewWithAccessibilityIdentifier("AddNoteButton") as? UIButton

        addButton?.simulateTouch()

        XCTAssertNotNil(addButton)
        let argumentCaptor = ArgumentCaptor<Note>()
        verify(mockNotesService, times(1)).save(note: argumentCaptor.capture())
        XCTAssertEqual(argumentCaptor.value?.name, "note2 (1)")
        XCTAssertEqual(argumentCaptor.value?.contents, "")
    }

    func testWhenUserAddsNote_SaveFailsShowsAlert() throws {
        enum Err: Error {
            case e1
        }
        let mockNotesService = MockNotesService()
        let expectedNotes = [Note(name: "note2", contents: UUID().uuidString)]
        stub(mockNotesService) { (stub) in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
            when(stub.save(note: any(Note.self))).thenThrow(Err.e1)
        }
        Container.default.register(NotesService.self) { _ in mockNotesService }
        viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "NotesListViewController") as NotesListViewController
        let navController = UINavigationController(rootViewController: UIViewController())
        navController.loadForTesting()
        navController.pushViewController(viewController, animated: false)
        RunLoop.current.singlePass()
        let tableView: UITableView? = viewController.view?.viewWithAccessibilityIdentifier("NotesTableView") as? UITableView
        let addButton = viewController.view?.viewWithAccessibilityIdentifier("AddNoteButton") as? UIButton

        addButton?.simulateTouch()

        XCTAssertNotNil(addButton)
        XCTAssertNotNil(tableView)
        XCTAssertEqual(viewController.notes.count, 1)
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 1)
        verify(mockNotesService, times(1)).save(note: any(Note.self))

        waitUntil(viewController.navigationController?.visibleViewController is UIAlertController)
        let alertVC = viewController.navigationController?.visibleViewController as? UIAlertController
        XCTAssertNotNil(alertVC, "Expected \(String(describing: viewController.navigationController?.visibleViewController)) to be UIAlertController")
        XCTAssertEqual(alertVC?.preferredStyle, .alert)
        XCTAssertEqual(alertVC?.message, Err.e1.localizedDescription)
        XCTAssertEqual(alertVC?.actions.count, 1)
        XCTAssertEqual(alertVC?.actions.first?.style, .default)
    }

    func testUserCanDeleteNote() throws {
        let mockNotesService = MockNotesService()
        let note2 = Note(name: "note2", contents: UUID().uuidString)
        let expectedNotes = [Note(name: "note1", contents: UUID().uuidString),
                             note2,
                             Note(name: "note3", contents: UUID().uuidString)]
        let expectedIndexPath = IndexPath(row: 1, section: 0)
        stub(mockNotesService) { (stub) in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
            when(stub.delete(note: any(Note.self))).thenDoNothing()
        }
        let mockTableView = objcStub(for: UITableView.self) { (stubber, mock) in
            stubber.when(mock.deleteRows(at: [expectedIndexPath], with: .fade)).thenDoNothing()
        }
        viewController = UIViewController.loadFromStoryboard(identifier: "NotesListViewController", forNavigation: true) { _ in
            Container.default.register(NotesService.self) { _ in mockNotesService }
        }

        let tableView: UITableView? = viewController.view?.viewWithAccessibilityIdentifier("NotesTableView") as? UITableView

        tableView?.dataSource?.tableView?(mockTableView, commit: .delete, forRowAt: expectedIndexPath)

        RunLoop.current.singlePass()
        let argumentCaptor = ArgumentCaptor<Note>()
        verify(mockNotesService, times(1)).delete(note: argumentCaptor.capture())
        XCTAssertEqual(argumentCaptor.value?.name, note2.name)
        XCTAssertEqual(argumentCaptor.value?.contents, note2.contents)
        objcVerify(mockTableView.deleteRows(at: [expectedIndexPath], with: .fade))
    }

    func testWhenUserDeletesNote_TableViewRespondsCorrectly() throws {
        let mockNotesService = MockNotesService()
        let expectedNotes = [Note(name: "note1", contents: UUID().uuidString),
                             Note(name: "note2", contents: UUID().uuidString),
                             Note(name: "note3", contents: UUID().uuidString)]
        let expectedIndexPath = IndexPath(row: 1, section: 0)
        stub(mockNotesService) { (stub) in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
            when(stub.delete(note: any(Note.self))).thenDoNothing()
        }

        viewController = UIViewController.loadFromStoryboard(identifier: "NotesListViewController", forNavigation: true) { _ in
            Container.default.register(NotesService.self) { _ in mockNotesService }
        }
        let tableView: UITableView? = viewController.view?.viewWithAccessibilityIdentifier("NotesTableView") as? UITableView

        tableView?.dataSource?.tableView?(tableView!, commit: .delete, forRowAt: expectedIndexPath)

        RunLoop.current.singlePass()
        XCTAssertEqual(viewController.tableView(tableView!, numberOfRowsInSection: 0), 2)
    }

    func testWhenUserDeletesNote_DeleteFailsShowsAlert() throws {
        enum Err: Error {
            case e1
        }
        let mockNotesService = MockNotesService()
        let expectedNotes = [Note(name: "note1", contents: UUID().uuidString),
                             Note(name: "note2", contents: UUID().uuidString),
                             Note(name: "note3", contents: UUID().uuidString)]
        let expectedIndexPath = IndexPath(row: 1, section: 0)
        stub(mockNotesService) { (stub) in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
            when(stub.delete(note: any(Note.self))).thenThrow(Err.e1)
        }
        Container.default.register(NotesService.self) { _ in mockNotesService }
        viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "NotesListViewController") as NotesListViewController
        let navController = UINavigationController(rootViewController: UIViewController())
        navController.loadForTesting()
        navController.pushViewController(viewController, animated: false)
        RunLoop.current.singlePass()
        let tableView: UITableView? = viewController.view?.viewWithAccessibilityIdentifier("NotesTableView") as? UITableView

        tableView?.dataSource?.tableView?(tableView!, commit: .delete, forRowAt: expectedIndexPath)

        RunLoop.current.singlePass()
        XCTAssertNotNil(tableView)
        XCTAssertEqual(viewController.notes.count, 3)
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 3)
        verify(mockNotesService, times(1)).delete(note: any(Note.self))

        waitUntil(viewController.navigationController?.visibleViewController is UIAlertController)
        let alertVC = viewController.navigationController?.visibleViewController as? UIAlertController
        XCTAssertNotNil(alertVC, "Expected \(String(describing: viewController.navigationController?.visibleViewController)) to be UIAlertController")
        XCTAssertEqual(alertVC?.preferredStyle, .alert)
        XCTAssertEqual(alertVC?.message, Err.e1.localizedDescription)
        XCTAssertEqual(alertVC?.actions.count, 1)
        XCTAssertEqual(alertVC?.actions.first?.style, .default)
    }

}
