//
//  NotesService.swift
//  UIKitWithStoryboard
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation
import Swinject

class NotesService {
    private static let notesURL: URL? = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask).first?
        .appendingPathComponent("notes")
    private static var notesURLString: String { notesURL?.absoluteString ?? "" }
    @DependencyInjected(name: NotesService.notesURLString) var directoryEnumerator: FileManager.DirectoryEnumerator?

    func writeNote(at url: URL, contents: FileWriteable) throws {
        try contents.write(to: url, atomically: true, encoding: .utf8)
    }

    func getNotes() -> Result<[Note], Error> {
        guard let directoryEnumerator = directoryEnumerator else {
            return .failure(FileError.unableToReadFromFile)
        }
        var notes = [Note]()
        while let url = directoryEnumerator.nextObject() as? URL,
              let result = Container.default.resolve(Result<String, Error>.self, name: "ReadFromFile", arguments: url, String.Encoding.utf8) {
            switch result {
                case .success(let contents):
                    notes.append(Note(name: url.deletingPathExtension().lastPathComponent, contents: contents))
                case .failure(let err):
                    return .failure(err)
            }
        }
        return .success(notes)
    }

}

extension NotesService {
    enum FileError: Error {
        case unableToReadFromFile
        case unableToWriteToFile
    }
}
