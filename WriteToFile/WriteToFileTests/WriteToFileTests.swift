//
//  WriteToFileTests.swift
//  WriteToFileTests
//
//  Created by thompsty on 1/4/21.
//

import XCTest
import Swinject
import Cuckoo

@testable import WriteToFile

class WriteToFileTests: XCTestCase {
    var service: NotesService!

    override func setUpWithError() throws {
        service = NotesService()
        Container.default.removeAll()
    }

    func testNoteIsCreatedToFile() throws {
        let mock = MockFileManager()
        let expectedPath = UUID().uuidString
        let expectedContent = UUID().uuidString.data(using: .utf8)
        let expectedAttributes: [FileAttributeKey: Any]? = nil
        stub(mock) { (stub) in
            when(stub.createFile(atPath: anyString(), contents: anyData(), attributes: anyFileAttributes())).thenReturn(true)
        }
        Container.default.register(Foundation.FileManager.self) { _ in mock }

        try service.createNote(at: expectedPath, contents: expectedContent)

        verify(mock, times(1)).createFile(atPath: expectedPath, contents: expectedContent, attributes: expectedAttributes)
    }

    func testNoteIsNotCreatedThrowsError() throws {
        let mock = MockFileManager()
        let expectedPath = UUID().uuidString
        let expectedContent = UUID().uuidString.data(using: .utf8)
        let expectedAttributes: [FileAttributeKey: Any]? = nil
        stub(mock) { (stub) in
            when(stub.createFile(atPath: anyString(), contents: anyData(), attributes: anyFileAttributes())).thenReturn(false)
        }
        Container.default.register(Foundation.FileManager.self) { _ in mock }

        XCTAssertThrowsError(try service.createNote(at: expectedPath, contents: expectedContent)) { error in
            XCTAssertEqual(error as? NotesService.FileError, NotesService.FileError.unableToWriteToFile)
        }
        verify(mock, times(1)).createFile(atPath: expectedPath, contents: expectedContent, attributes: expectedAttributes)
    }

    func testFileManagerDoesNotExist_CreateThrowsError() throws {
        XCTAssertThrowsError(try service.createNote(at: "", contents: nil)) { err in
            XCTAssertEqual(err as? NotesService.FileError, .unableToWriteToFile)
        }
    }

    func testFileManagerDoesNotExist_ReadReturnsFailure() throws {
        switch service.readNote(at: "") {
            case .failure(let err):
            XCTAssertEqual(err, .unableToReadFromFile)
            case .success:
            XCTFail("This was not supposed to be successful, you have no FileManager")
        }
    }

    func testNoteIsReadFromFile() throws {
        let expectedNoteContent: Data? = UUID().uuidString.data(using: .utf8)
        let mock = MockFileManager()
        let path = UUID().uuidString
        stub(mock) { (stub) in
            when(stub.contents(atPath: anyString())).thenReturn(expectedNoteContent)
        }
        Container.default.register(Foundation.FileManager.self) { _ in mock }

        switch service.readNote(at: path) {
            case .failure(let err):
            XCTFail("readNote should have succeeded, unexpected error: \(err)")
            case .success(let data):
            XCTAssertEqual(data, expectedNoteContent)
        }

        verify(mock, times(1)).contents(atPath: path)
    }

    func testNoteIsReadHasNoDataReturnsFailure() throws {
        let mock = MockFileManager()
        stub(mock) { (stub) in
            when(stub.contents(atPath: anyString())).thenReturn(nil)
        }
        Container.default.register(Foundation.FileManager.self) { _ in mock }

        switch service.readNote(at: "pathy") {
            case .failure(let err):
            XCTAssertEqual(err, .unableToReadFromFile)
            case .success:
            XCTFail("Expecting failure with error")
        }
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

    func testNotesServiceCanWriteDataToAFile() throws {
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("txt")
        addTeardownBlock {
            // swiftlint:disable:next force_try
            try! Foundation.FileManager.default.removeItem(at: path)
        }
        let expectedContents = "FINDME\(UUID().uuidString)"

        try service.writeData(to: path, contents: expectedContents.data(using: .utf8)!)

        let fileData = try Data(contentsOf: path)
        XCTAssertEqual(String(data: fileData, encoding: .utf8), expectedContents)
    }

    func testNotesServiceRethrows_DataFileWritingErrors() throws {
        let path = URL(string: NSTemporaryDirectory())!.appendingPathComponent(UUID().uuidString).appendingPathExtension("txt")
        addTeardownBlock {
            // keep this around...just in case
            try? Foundation.FileManager.default.removeItem(at: path)
        }
        let expectedContents = "FINDME\(UUID().uuidString)"
        var foundationError: Error?
        do {
            try expectedContents.data(using: .utf8)?.write(to: path)
        } catch let err {
            foundationError = err
        }
        XCTAssertNotNil(foundationError)

        XCTAssertThrowsError(try service.writeData(to: path, contents: expectedContents.data(using: .utf8)!)) { err in
            XCTAssertEqual(err.localizedDescription, foundationError?.localizedDescription)
        }

        do {
            _ = try Data(contentsOf: path)
            fatalError("WARNING, file contents was readable, this test just persisted data that it should not have")
        } catch { }
    }

}
