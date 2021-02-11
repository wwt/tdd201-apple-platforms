//
//  NotesService.swift
//  UIKitWithStoryboard
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation

class NotesService {

    func writeNote(at url: URL, contents: FileWriteable) throws {
        try contents.write(to: url, atomically: true, encoding: .utf8)
    }

}

extension NotesService {
    enum FileError: Error {
        case unableToReadFromFile
        case unableToWriteToFile
    }
}
