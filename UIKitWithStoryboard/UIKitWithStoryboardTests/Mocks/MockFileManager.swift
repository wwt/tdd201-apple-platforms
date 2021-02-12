//
//  MockFileManager.swift
//  UIKitWithStoryboardTests
//
//  Created by Heather Meadow on 2/12/21.
//

import Foundation

// NOTE: This is purely for Cuckoo to pick up on the appropriate methods and create a mock, nothing more
// If you need to add methods to your mock, add them here first
class FileManager: Foundation.FileManager {
    override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        super.urls(for: directory, in: domainMask)
    }

    override func url(for directory: FileManager.SearchPathDirectory,
                      in domain: FileManager.SearchPathDomainMask,
                      appropriateFor url: URL?,
                      create shouldCreate: Bool) throws -> URL {
        try super.url(for: directory,
                      in: domain,
                      appropriateFor: url,
                      create: shouldCreate)
    }

    override func fileExists(atPath path: String) -> Bool {
        super.fileExists(atPath: path)
    }

    override func removeItem(at URL: URL) throws {
        try super.removeItem(at: URL)
    }

    override func enumerator(atPath path: String) -> FileManager.DirectoryEnumerator? {
        super.enumerator(atPath: path)
    }
}
