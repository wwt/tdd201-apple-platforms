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
        let expectedContent: Data? = UUID().uuidString.data(using: .utf8)
        stub(mock) { (stub) in
            when(stub.createFile(atPath: anyString(), contents: any(Data.self), attributes: any()))
                .thenReturn(true)
        }
        Container.default.register(Foundation.FileManager.self) { _ in mock }
        
        try service.createNote(at: expectedPath, contents: expectedContent)
        
        verify(mock, times(1)).createFile(atPath: expectedPath, contents: expectedContent, attributes: [:])
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
        case .failure(_):
            XCTFail("You done failed")
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
        case .failure(let error):
            XCTAssertEqual(error, .unableToReadFromFile)
        case .success(_):
            XCTFail("Expecting failure with error")
        }
    }
}
