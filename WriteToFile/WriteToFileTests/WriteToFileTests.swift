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
        let expectedAttributes: [FileAttributeKey : Any]? = nil
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
        let expectedAttributes: [FileAttributeKey : Any]? = nil
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
        case .success(_):
            XCTFail("This was not supposed to be successful, you have no FileManager")
        }
    }
    
    func testNoteIsReadFromFile() throws {
        let expectedNoteContent:Data? = UUID().uuidString.data(using: .utf8)
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
        case .success(_):
            XCTFail("Expecting failure with error")
        }
    }
}
