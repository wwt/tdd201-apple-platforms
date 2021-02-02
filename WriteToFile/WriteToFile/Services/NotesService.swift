//
//  NotesService.swift
//  WriteToFile
//
//  Created by Heather Meadow on 2/2/21.
//

import Foundation

class NotesService {
    
    @DependencyInjected var fileManager:FileManager?
    
    func readNote(at path: String) -> Result<Data, FileError> {
        guard let data = fileManager?.contents(atPath: path) else {
            return .failure(.unableToReadFromFile)
        }
        return .success(data)
    }
    
    func createNote(at path: String, contents data: Data?) throws {
        guard let succeeded = fileManager?.createFile(atPath: path, contents: data),
              succeeded else {
            throw FileError.unableToWriteToFile
        }
    }
}

extension NotesService {
    enum FileError: Error {
        case unableToReadFromFile
        case unableToWriteToFile
    }
}
