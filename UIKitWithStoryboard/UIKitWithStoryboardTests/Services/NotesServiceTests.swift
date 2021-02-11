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
    let notesURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("notes")

    override func setUpWithError() throws {
        service = NotesService()
        Container.default.removeAll()
    }

    func testNotesServiceCanReadAllTheNotesFromDirectory() throws {
        let mockEnumerator = MockDirectoryEnumerator()
        let expectedUrl1 = URL(fileURLWithPath: "User/user1/test1.txt")
        let expectedUrl2 = URL(fileURLWithPath: "User/user1/test2.txt")
        let expectedContents1 = UUID().uuidString
        let expectedContents2 = UUID().uuidString
        stub(mockEnumerator) { (stub) in
            when(stub.nextObject())
                .thenReturn(expectedUrl1)
                .thenReturn(expectedUrl2)
                .thenReturn(nil)
        }
        Container.default.register(FileManager.DirectoryEnumerator.self,
                                   name: notesURL.absoluteString) { _ in mockEnumerator }
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
    }

    func testNotesServiceReturnsError_WhenItCannotGetDirectoryEnumerator() throws {
        let result = service.getNotes()

        switch result {
            case .success: XCTFail("Got unexpected notes, scary")
            case .failure(let err):
                XCTAssertEqual(err as? NotesService.FileError, .unableToReadFromFile)
        }
    }

    func testNotesServiceReturnsError_WhenGettingContentsOfFileThrowsError() throws {
        enum Err: Error {
            case e1
        }
        let mockEnumerator = MockDirectoryEnumerator()
        let expectedUrl1 = URL(fileURLWithPath: "User/user1/test1.txt")
        let expectedUrl2 = URL(fileURLWithPath: "User/user1/test2.txt")
        stub(mockEnumerator) { (stub) in
            when(stub.nextObject())
                .thenReturn(expectedUrl1)
                .thenReturn(expectedUrl2)
                .thenReturn(nil)
        }
        Container.default.register(FileManager.DirectoryEnumerator.self,
                                   name: notesURL.absoluteString) { _ in mockEnumerator }
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

    func testNotesServiceCanWriteAStringToAFile() throws {
        let expectedPath = URL(string: "file://path.txt")!
        let mock = MockFileWriteable()
        stub(mock) { (stub) in
            when(stub.write(to: anyURL(), atomically: any(), encoding: anyStringEncoding())).thenDoNothing()
        }

        try service.writeNote(at: expectedPath, contents: mock)

        verify(mock, times(1)).write(to: expectedPath, atomically: true, encoding: String.Encoding.utf8)
    }

    func testNotesServiceRethrowsError_IfWritingToFileIsNotPossible() throws {
        enum TestError: Error {
            case borked
        }

        let expectedPath = URL(string: "file://path.txt")!
        let mock = MockFileWriteable()
        stub(mock) { (stub) in
            when(stub.write(to: anyURL(), atomically: any(), encoding: anyStringEncoding())).thenThrow(TestError.borked)
        }

        XCTAssertThrowsError(try service.writeNote(at: expectedPath, contents: mock)) { err in
            XCTAssertEqual(err as? TestError, .borked)
        }

        verify(mock, times(1)).write(to: expectedPath, atomically: true, encoding: String.Encoding.utf8)
    }
}
