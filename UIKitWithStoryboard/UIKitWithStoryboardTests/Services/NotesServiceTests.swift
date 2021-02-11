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

    override func setUpWithError() throws {
        service = NotesService()
        Container.default.removeAll()
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
