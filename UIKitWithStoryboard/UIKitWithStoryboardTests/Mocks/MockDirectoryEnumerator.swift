//
//  MockDirectoryEnumerator.swift
//  UIKitWithStoryboardTests
//
//  Created by Heather Meadow on 2/10/21.
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
}

class DirectoryEnumerator: Foundation.FileManager.DirectoryEnumerator {
    override func nextObject() -> Any? {
        super.nextObject()
    }
}
