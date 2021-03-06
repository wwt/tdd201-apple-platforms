//
//  NotesServiceTests.swift
//  UIKitWithStoryboardTests
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation
import XCTest
import Swinject
import Cuckoo

@testable import UIKitWithStoryboard

class NotesServiceTests: XCTestCase {
    var service: NotesService!
    let notesURL: URL = Foundation.FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask).first!

    override func setUpWithError() throws {
        service = NotesService()
        Container.default.removeAll()
    }

    func testNotesServiceCanReadAllTheNotesFromDirectory() throws {
        let mockFileManager = MockFileManager()
        let mockEnumerator = MockDirectoryEnumerator()
        let expectedUrl1 = notesURL.appendingPathComponent("test1.txt")
        let expectedUrl2 = notesURL.appendingPathComponent("test2.txt")
        let expectedContents1 = UUID().uuidString
        let expectedContents2 = UUID().uuidString
        stub(mockEnumerator) { (stub) in
            when(stub.nextObject())
                .thenReturn(expectedUrl1.lastPathComponent)
                .thenReturn(expectedUrl2.lastPathComponent)
                .thenReturn(nil)
        }
        stub(mockFileManager) { (stub) in
            when(stub.urls(for: any(), in: any())).thenReturn([notesURL])
            when(stub.enumerator(atPath: anyString())).thenReturn(mockEnumerator)
        }
        Container.default.register(Foundation.FileManager.self) { _ in mockFileManager }
        Container.default.register(Result<String, Error>.self, name: "ReadFromFile") {(_:Resolver, url: URL, encoding: String.Encoding) in
            XCTAssertEqual(encoding, .utf8)
            switch url {
                case expectedUrl1:
                    return .success(expectedContents1)
                case expectedUrl2:
                    return .success(expectedContents2)
                default:
                    return .failure(NotesService.FileError.unableToReadFromFile)
            }
        }

        let result = service.getNotes()

        switch result {
            case .success(let notes):
                XCTAssertEqual(notes.count, 2)
                XCTAssertEqual(notes.first?.name, "test1")
                XCTAssertEqual(notes.first?.contents, expectedContents1)
                XCTAssertEqual(notes.last?.name, "test2")
                XCTAssertEqual(notes.last?.contents, expectedContents2)
            case .failure(let err):
                XCTFail("I expected notes. Give me notes. Instead got \(err.localizedDescription)")
        }

        verify(mockFileManager, times(1)).enumerator(atPath: notesURL.path)
        verify(mockEnumerator, atLeastOnce()).nextObject()

    }

    func testNotesServiceReturnsError_WhenItCannotGetDirectoryEnumerator() throws {
        let mockFileManager = MockFileManager()
        stub(mockFileManager) { (stub) in
            when(stub.urls(for: any(), in: any())).thenReturn([notesURL])
            when(stub.enumerator(atPath: anyString())).thenReturn(nil)
        }
        Container.default.register(Foundation.FileManager.self) { _ in mockFileManager }

        let result = service.getNotes()

        switch result {
            case .success: XCTFail("Got unexpected notes, scary")
            case .failure(let err):
                XCTAssertEqual(err as? NotesService.FileError, .unableToReadFromFile)
        }
    }

    func testNotesServiceReturnsError_WhenGettingContentsOfFileThrowsError() throws {
        let mockFileManager = MockFileManager()
        let mockEnumerator = MockDirectoryEnumerator()
        let expectedUrl1 = notesURL.appendingPathComponent("test1.txt")
        let expectedUrl2 = notesURL.appendingPathComponent("test2.txt")
        enum Err: Error {
            case e1
        }
        stub(mockEnumerator) { (stub) in
            when(stub.nextObject())
                .thenReturn(expectedUrl1.lastPathComponent)
                .thenReturn(expectedUrl2.lastPathComponent)
                .thenReturn(nil)
        }
        stub(mockFileManager) { (stub) in
            when(stub.urls(for: any(), in: any())).thenReturn([notesURL])
            when(stub.enumerator(atPath: anyString())).thenReturn(mockEnumerator)
        }
        Container.default.register(Foundation.FileManager.self) { _ in mockFileManager }
        Container.default.register(Result<String, Error>.self, name: "ReadFromFile") {(_:Resolver, _: URL, _: String.Encoding) in
            .failure(Err.e1)
        }

        let result = service.getNotes()

        switch result {
            case .success: XCTFail("Got unexpected notes")
            case .failure(let err):
                XCTAssertEqual(err as? Err, .e1)
        }
    }

    func testServiceCanSaveANote() throws {
        Container.default.register(Foundation.FileManager.self) { _ in FileManager.default }
        struct FakeNote: NoteWriteable {
            let name: String
            let contents: MockFileWriteable
        }
        let mock = MockFileWriteable()
        stub(mock) { stub in
            when(stub.write(to: anyURL(), atomically: true, encoding: anyStringEncoding())).thenDoNothing()
        }
        let fakeNote = FakeNote(name: UUID().uuidString, contents: mock)

        try service.save(note: fakeNote)

        verify(mock, times(1)).write(to: notesURL.appendingPathComponent(fakeNote.name).appendingPathExtension("txt"), atomically: true, encoding: String.Encoding.utf8)
    }

    func testServiceThrowsAnError_WhenItCannotSaveANote() throws {
        Container.default.register(Foundation.FileManager.self) { _ in FileManager.default }
        struct FakeNote: NoteWriteable {
            let name: String
            let contents: MockFileWriteable
        }
        let mock = MockFileWriteable()
        stub(mock) { stub in
            when(stub.write(to: anyURL(), atomically: true, encoding: anyStringEncoding())).thenThrow(NotesService.FileError.unableToReadFromFile)
        }
        let fakeNote = FakeNote(name: UUID().uuidString, contents: mock)

        XCTAssertThrowsError(try service.save(note: fakeNote)) { err in
            XCTAssertEqual(err as? NotesService.FileError, .unableToReadFromFile)
        }

        verify(mock, times(1)).write(to: notesURL.appendingPathComponent(fakeNote.name).appendingPathExtension("txt"), atomically: true, encoding: String.Encoding.utf8)
    }

    func testServiceThrowsAnErrorWhileSavingANote_WhenItCannotFindTheFileURL() throws {
        let mock = MockFileManager()
        stub(mock) { stub in
            when(stub.urls(for: any(), in: any())).thenReturn([])
        }
        Container.default.register(Foundation.FileManager.self) { _ in mock }

        let note = Note(name: "", contents: "")

        XCTAssertThrowsError(try service.save(note: note)) { err in
            XCTAssertEqual(err as? NotesService.FileError, .unableToReadFromFile)
        }

        verify(mock, times(1)).urls(for: any(), in: any())
    }

    func testNotesServiceCanDeleteNote() throws {
        let note = Note(name: "note1", contents: UUID().uuidString)
        let mock = MockFileManager()
        Container.default.register(Foundation.FileManager.self) { _ in mock }
        stub(mock) { stub in
            when(stub.urls(for: any(), in: any())).thenReturn([notesURL])
            when(stub.fileExists(atPath: anyString())).thenReturn(true)
            when(stub.removeItem(at: anyURL())).thenDoNothing()
        }

        try service.delete(note: note)

        let expectedURL = notesURL.appendingPathComponent(note.name).appendingPathExtension("txt")
        verify(mock, times(1)).fileExists(atPath: "\(expectedURL.path)")
        verify(mock, times(1)).removeItem(at: expectedURL)
    }

    func testNoteServiceReThrowsError_IfFileCannotBeFound() throws {
        let note = Note(name: "note1", contents: UUID().uuidString)
        let mock = MockFileManager()
        Container.default.register(Foundation.FileManager.self) { _ in mock }
        stub(mock) { stub in
            when(stub.urls(for: any(), in: any())).thenReturn([notesURL])
            when(stub.fileExists(atPath: anyString())).thenReturn(false)
            when(stub.removeItem(at: anyURL())).thenDoNothing()
        }

        XCTAssertThrowsError(try service.delete(note: note)) { err in
            XCTAssertEqual(err as? NotesService.FileError, .unableToDeleteFile)
        }

        let expectedURL = notesURL.appendingPathComponent(note.name).appendingPathExtension("txt")
        verify(mock, times(1)).fileExists(atPath: "\(expectedURL.path)")
        verify(mock, times(0)).removeItem(at: anyURL())
    }

    func testNoteServiceReThrowsError_IfFileCannotBeDeleted() throws {
        enum Err: Error {
            case e1
        }
        let note = Note(name: "note1", contents: UUID().uuidString)
        let mock = MockFileManager()
        Container.default.register(Foundation.FileManager.self) { _ in mock }
        stub(mock) { stub in
            when(stub.urls(for: any(), in: any())).thenReturn([notesURL])
            when(stub.fileExists(atPath: anyString())).thenReturn(true)
            when(stub.removeItem(at: anyURL())).thenThrow(Err.e1)
        }

        XCTAssertThrowsError(try service.delete(note: note)) { err in
            XCTAssertEqual(err as? Err, .e1)
        }

        let expectedURL = notesURL.appendingPathComponent(note.name).appendingPathExtension("txt")
        verify(mock, times(1)).fileExists(atPath: "\(expectedURL.path)")
        verify(mock, times(1)).removeItem(at: anyURL())
    }

    func testNoteServiceReThrowsError_IfNoFileManagerInjected() throws {
        let note = Note(name: "note1", contents: UUID().uuidString)

        XCTAssertThrowsError(try service.delete(note: note)) { err in
            XCTAssertEqual(err as? NotesService.FileError, .unableToDeleteFile)
        }
    }

}
