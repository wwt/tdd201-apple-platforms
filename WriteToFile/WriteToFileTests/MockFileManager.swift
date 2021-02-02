//
//  MockFileManager.swift
//  WriteToFileTests
//
//  Created by Heather Meadow on 2/2/21.
//

import Foundation

//NOTE: This is purely for Cuckoo to pick up on the appropriate methods and create a mock, nothing more
//If you need to add methods to your mock, add them here first
class FileManager: Foundation.FileManager {
    override func contents(atPath path: String) -> Data? {
        return super.contents(atPath: path)
    }
    
    override func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]? = nil) -> Bool {
        return super.createFile(atPath: path, contents: data, attributes: attr)
    }
}
