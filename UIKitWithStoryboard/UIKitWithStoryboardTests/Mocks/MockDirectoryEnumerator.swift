//
//  MockDirectoryEnumerator.swift
//  UIKitWithStoryboardTests
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation

// NOTE: This is purely for Cuckoo to pick up on the appropriate methods and create a mock, nothing more
// If you need to add methods to your mock, add them here first
class DirectoryEnumerator: Foundation.FileManager.DirectoryEnumerator {
    override func nextObject() -> Any? {
        super.nextObject()
    }
}
