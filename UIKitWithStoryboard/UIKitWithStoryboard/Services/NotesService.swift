//
//  NotesService.swift
//  UIKitWithStoryboard
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation
import Swinject

class NotesService {
    private static var notesURL: URL? {
        Container.default.resolve(FileManager.self)?
            .urls(for: .documentDirectory, in: .userDomainMask).first
    }

    @DependencyInjected var fileManager: Foundation.FileManager?

    func save<N: NoteWriteable>(note: N) throws {
        guard let notesURL = Self.notesURL else {
            throw FileError.unableToReadFromFile
        }
        try note.contents.write(to: notesURL.appendingPathComponent(note.name).appendingPathExtension("txt"), atomically: true, encoding: .utf8)
    }

    func getNotes() -> Result<[Note], Error> {
        guard let notesURL = Self.notesURL,
              let directoryEnumerator = fileManager?.enumerator(atPath: notesURL.path) else {
            return .failure(FileError.unableToReadFromFile)
        }
        var notes = [Note]()

        while let file = directoryEnumerator.nextObject() as? String,
              let result = Container.default.resolve(Result<String, Error>.self, name: "ReadFromFile",
                                                     arguments: notesURL.appendingPathComponent(file),
                                                     String.Encoding.utf8) {

            switch result {
                case .success(let contents):
                    notes.append(Note(name: URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent,
                                      contents: contents))
                case .failure(let err):
                    return .failure(err)
            }

        }
        return .success(notes)
    }

    func delete(note: Note) throws {
        guard let url = Self.notesURL?.appendingPathComponent(note.name).appendingPathExtension("txt"),
           fileManager?.fileExists(atPath: url.path) == true else {
            throw FileError.unableToDeleteFile
        }
        try fileManager?.removeItem(at: url)
    }

}

extension NotesService {
    enum FileError: Error {
        case unableToReadFromFile
        case unableToWriteToFile
        case unableToDeleteFile
    }
}
