//
//  NotesListUITests.swift
//  UIKitWithStoryboardTests
//
//  Created by thompsty on 1/4/21.
//
// swiftlint:disable type_body_length

import XCTest
import UIUTest
import Swinject
import Cuckoo

@testable import UIKitWithStoryboard

class NotesListUITests: XCTestCase, UIUStoryboardTestable {
    typealias ViewControllerUnderTest = NotesListViewController

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

    func testViewControllerCanLoadFromStoryboard() throws {
        XCTAssertNoThrow(try getViewController())
    }

    func testViewControllerHasCorrectTitle() throws {
        XCTAssertEqual(try getViewController().title, "Notes")
    }

    func testViewControllerHasATitleLabel() throws {
        let viewController = try getViewController()

        XCTAssertNotNil(viewController.titleLabel, "Title Label should exist on view")
        XCTAssertEqual(viewController.titleLabel?.text, "Notes")
    }

    func testViewControllerHasAnAddNoteButton() throws {
        let viewController = try getViewController()

        XCTAssertNotNil(viewController.addButton, "Add Note button should exist on view")
        XCTAssertEqual(viewController.addButton?.willRespondToUser, true, "Add Note button should respond to user")
    }

    func testTableViewContainsNotes() throws {
        let expectedNotes = [Note(name: "note1", contents: UUID().uuidString),
                             Note(name: "note2", contents: UUID().uuidString)]
        MockNotesService().stub { stub in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
        }.registerIn(Container.default)
        let viewController = try getViewController()

        XCTAssertNotNil(viewController.notesTableView, "Expected to get a tableview from the view controller")
        XCTAssertEqual(viewController.notesTableView?.numberOfRows(inSection: 0), expectedNotes.count)
        XCTAssertEqual(viewController.notesTableView?.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text, expectedNotes.first?.name)
        XCTAssertEqual(viewController.notesTableView?.cellForRow(at: IndexPath(row: 1, section: 0))?.textLabel?.text, expectedNotes.last?.name)
    }

    func testUserCanAddANote() throws {
        let expectedNote = Note(name: "note1", contents: UUID().uuidString)
        let expectedNotes = [expectedNote,
                             Note(name: "note2", contents: UUID().uuidString)]
        let mockNotesService = MockNotesService().stub { stub in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
            when(stub.save(note: any(Note.self))).thenDoNothing()
        }.registerIn(Container.default)
        let viewController = try getViewController()

        viewController.addButton?.simulateTouch()

        let argumentCaptor = ArgumentCaptor<Note>()
        verify(mockNotesService, times(1)).save(note: argumentCaptor.capture())
        XCTAssertEqual(argumentCaptor.value?.name, "note3")
        XCTAssertEqual(argumentCaptor.value?.contents, "")

        XCTAssertNotNil(viewController.notesTableView, "Expected to get a tableview from the view controller")
        XCTAssertEqual(viewController.notesTableView?.numberOfRows(inSection: 0), expectedNotes.count+1)
        XCTAssertEqual(viewController.notesTableView?.cellForRow(at: IndexPath(row: expectedNotes.count, section: 0))?.textLabel?.text, argumentCaptor.value?.name)
    }

    func testWhenUserAddsNote_TheNameIsUnique() throws {
        let expectedNotes = [Note(name: "note2", contents: UUID().uuidString)]
        let mockNotesService = MockNotesService().stub { stub in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
            when(stub.save(note: any(Note.self))).thenDoNothing()
        }.registerIn(Container.default)
        let viewController = try getViewController()

        viewController.addButton?.simulateTouch()

        let argumentCaptor = ArgumentCaptor<Note>()
        verify(mockNotesService, times(1)).save(note: argumentCaptor.capture())
        XCTAssertEqual(argumentCaptor.value?.name, "note2 (1)")
        XCTAssertEqual(argumentCaptor.value?.contents, "")
    }

    func testSelectNoteGoesToDetails() throws {
        let expectedNote = Note(name: UUID().uuidString, contents: UUID().uuidString)
        let expectedNotes = [expectedNote,
                             Note(name: "note2", contents: UUID().uuidString)]
        MockNotesService().stub { stub in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
        }.registerIn(Container.default)
        let viewController = UIViewController.loadFromStoryboard(identifier: storyboardIdentifier, forNavigation: true)
        let index = IndexPath(row: 0, section: 0)

        viewController?.notesTableView?.simulateTouch(at: index)
        RunLoop.current.singlePass()

        let topVC: NoteDetailViewController? = viewController?.navigationController?.topViewController as? NoteDetailViewController
        XCTAssertNotNil(topVC, "Expected top view controller to be NoteDetailViewController")
        XCTAssertEqual(topVC?.note?.name, expectedNote.name)
        XCTAssertEqual(topVC?.note?.contents, expectedNote.contents)

        XCTAssertEqual(viewController?.notesTableView?.cellIsSelected(at: index), false, "Cell should not be selected after navigation")
    }

    func testWhenUserDeletesNote_UserIsPresentedConfirmModal() throws {
        let expectedNotes = [Note(name: "note1", contents: UUID().uuidString),
                             Note(name: "note2", contents: UUID().uuidString),
                             Note(name: "note3", contents: UUID().uuidString)]
        let expectedIndexPath = IndexPath(row: 1, section: 0)
        let mockNotesService = MockNotesService().stub { stub in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
            when(stub.delete(note: any(Note.self))).thenDoNothing()
        }.registerIn(Container.default)
        let viewController = try getViewController()
        let tableView = viewController.notesTableView

        tableView?.dataSource?.tableView?(tableView!, commit: .delete, forRowAt: expectedIndexPath)

        let alertVC = viewController.presentedViewController as? UIAlertController
        XCTAssertNotNil(alertVC, "Expected \(String(describing: viewController.presentedViewController)) to be UIAlertController")
        XCTAssertEqual(alertVC?.preferredStyle, .alert)
        XCTAssertEqual(alertVC?.title, "Confirm delete")
        XCTAssertEqual(alertVC?.message, "Are you sure you want to delete?")
        XCTAssertEqual(alertVC?.actions.count, 2)
        XCTAssertEqual(alertVC?.actions.first?.style, .cancel)
        XCTAssertEqual(alertVC?.actions.first?.title, "No")
        XCTAssertEqual(alertVC?.actions.last?.style, .destructive)
        XCTAssertEqual(alertVC?.actions.last?.title, "Yes")

        verify(mockNotesService, times(0)).delete(note: any(Note.self))
        XCTAssertEqual(viewController.notesTableView?.numberOfRows(inSection: 0), 3)
        XCTAssert(viewController.notesTableView?.visibleCells.count ?? 0 > 1, "At least 1 cell should be visible")

    }

    func testWhenUserDeletesNote_UserConfirmsDelete() throws {
        let note2 = Note(name: "note2", contents: UUID().uuidString)
        let expectedNotes = [Note(name: "note1", contents: UUID().uuidString),
                             note2,
                             Note(name: "note3", contents: UUID().uuidString)]
        let expectedIndexPath = IndexPath(row: 1, section: 0)
        let mockNotesService = MockNotesService().stub { stub in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
            when(stub.delete(note: any(Note.self))).thenDoNothing()
        }.registerIn(Container.default)
        let viewController = try getViewController()
        let tableView = viewController.notesTableView

        tableView?.dataSource?.tableView?(tableView!, commit: .delete, forRowAt: expectedIndexPath)
        let alertVC = viewController.presentedViewController as? UIAlertController
        alertVC?.action(withStyle: .destructive)?.simulateTouch()

        let argumentCaptor = ArgumentCaptor<Note>()
        verify(mockNotesService, times(1)).delete(note: argumentCaptor.capture())
        XCTAssertEqual(argumentCaptor.value?.name, note2.name)
        XCTAssertEqual(argumentCaptor.value?.contents, note2.contents)
        XCTAssertEqual(viewController.notesTableView?.numberOfRows(inSection: 0), 2)
        XCTAssert(viewController.notesTableView?.visibleCells.count ?? 0 > 1, "At least 1 cell should be visible")
    }

    func testWhenUserDeletesNote_UserCancelsDelete() throws {
        let expectedNotes = [Note(name: "note1", contents: UUID().uuidString),
                             Note(name: "note2", contents: UUID().uuidString),
                             Note(name: "note3", contents: UUID().uuidString)]
        let expectedIndexPath = IndexPath(row: 1, section: 0)
        let mockNotesService = MockNotesService().stub { stub in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
            when(stub.delete(note: any(Note.self))).thenDoNothing()
        }.registerIn(Container.default)
        let viewController = try getViewController()
        let tableView = viewController.notesTableView

        tableView?.dataSource?.tableView?(tableView!, commit: .delete, forRowAt: expectedIndexPath)
        let alertVC = viewController.presentedViewController as? UIAlertController
        alertVC?.action(withStyle: .cancel)?.simulateTouch()

        verify(mockNotesService, times(0)).delete(note: any(Note.self))
        XCTAssertEqual(viewController.notesTableView?.numberOfRows(inSection: 0), 3)
        XCTAssert(viewController.notesTableView?.visibleCells.count ?? 0 > 1, "At least 1 cell should be visible")
    }

    func testWhenUserAddsNote_FailedSaveShowsAlert() throws {
        enum Err: Error {
            case e1
        }
        let expectedNotes = [Note(name: "note1", contents: UUID().uuidString)]
        let mockNotesService = MockNotesService().stub { stub in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
            when(stub.save(note: any(Note.self))).thenThrow(Err.e1)
        }.registerIn(Container.default)
        let viewController = try getViewController()

        viewController.addButton?.simulateTouch()

        let alertVC = viewController.presentedViewController as? UIAlertController
        XCTAssertNotNil(alertVC, "Expected \(String(describing: viewController.presentedViewController)) to be UIAlertController")
        XCTAssertEqual(alertVC?.preferredStyle, .alert)
        XCTAssertEqual(alertVC?.title, "Unable to add note")
        XCTAssertEqual(alertVC?.message, Err.e1.localizedDescription)
        XCTAssertEqual(alertVC?.actions.count, 1)
        XCTAssertEqual(alertVC?.actions.first?.style, .default)
        XCTAssertEqual(alertVC?.actions.first?.title, "Ok")

        verify(mockNotesService, times(1)).save(note: any(Note.self))
        XCTAssertEqual(viewController.notesTableView?.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(viewController.notesTableView?.visibleCells.count, 1)
    }

    func testWhenUserDeletesNote_FailedDeleteShowsAlert() throws {
        enum Err: Error {
            case e1
        }
        let expectedNotes = [Note(name: "note1", contents: UUID().uuidString),
                             Note(name: "note2", contents: UUID().uuidString),
                             Note(name: "note3", contents: UUID().uuidString)]
        let expectedIndexPath = IndexPath(row: 1, section: 0)
        let mockNotesService = MockNotesService().stub { stub in
            when(stub.getNotes()).thenReturn(.success(expectedNotes))
            when(stub.delete(note: any(Note.self))).thenThrow(Err.e1)
        }.registerIn(Container.default)
        let viewController = try getViewController()
        let tableView = viewController.notesTableView

        tableView?.dataSource?.tableView?(tableView!, commit: .delete, forRowAt: expectedIndexPath)
        var alertVC = viewController.presentedViewController as? UIAlertController
        alertVC?.action(withStyle: .destructive)?.simulateTouch()

        waitUntil(viewController.presentedViewController !== alertVC)
        alertVC = viewController.presentedViewController as? UIAlertController
        XCTAssertNotNil(alertVC, "Expected \(String(describing: viewController.presentedViewController)) to be UIAlertController")
        XCTAssertEqual(alertVC?.preferredStyle, .alert)
        XCTAssertEqual(alertVC?.title, "Unable to delete note")
        XCTAssertEqual(alertVC?.message, Err.e1.localizedDescription)
        XCTAssertEqual(alertVC?.actions.count, 1)
        XCTAssertEqual(alertVC?.actions.first?.style, .default)
        XCTAssertEqual(alertVC?.actions.first?.title, "Ok")

        verify(mockNotesService, times(1)).delete(note: any(Note.self))
        XCTAssertEqual(viewController.notesTableView?.numberOfRows(inSection: 0), 3)
        XCTAssert(viewController.notesTableView?.visibleCells.count ?? 0 > 1, "At least 1 cell should be visible")
    }

    func testDataIsGatheredAtViewWillAppearAndTableViewIsUpdated() throws {
        let mockNotesService = MockNotesService().stub { stub in
            when(stub.getNotes())
                .thenReturn(.success([]))
                .thenReturn(.success([Note(name: "Added note", contents: "That was updated")]))
        }.registerIn(Container.default)
        let viewController = try getViewController()

        viewController.viewWillAppear(false)

        verify(mockNotesService, times(2)).getNotes()
        XCTAssertEqual(viewController.notesTableView?.visibleCells.count, 1)
    }

    func testWhenUserDeletesNote_CellIsDeletedWithDeleteRows() throws {
        let expectedIndexPath = IndexPath(row: 0, section: 0)
        MockNotesService().stub { stub in
            when(stub.getNotes()).thenReturn(.success([Note(name: "note1", contents: UUID().uuidString)]))
            when(stub.delete(note: any(Note.self))).thenDoNothing()
        }.registerIn(Container.default)
        let mockTableView = objcStub(for: UITableView.self) { (stubber, mock) in
            stubber.when(mock.deleteRows(at: [expectedIndexPath], with: .fade)).thenDoNothing()
        }
        let viewController = try getViewController()

        viewController.notesTableView?.dataSource?.tableView?(mockTableView, commit: .delete, forRowAt: expectedIndexPath)
        let alertVC = viewController.presentedViewController as? UIAlertController
        alertVC?.action(withStyle: .destructive)?.simulateTouch()

        objcVerify(mockTableView.deleteRows(at: [expectedIndexPath], with: .fade))
    }
}

fileprivate extension UIViewController {
    var titleLabel: UILabel? { view?.viewWithAccessibilityIdentifier("TitleLabel") as? UILabel }
    var addButton: UIButton? { view?.viewWithAccessibilityLabel("Add note") as? UIButton }
    var notesTableView: UITableView? { view?.viewWithAccessibilityIdentifier("NotesTableView") as? UITableView }
}
