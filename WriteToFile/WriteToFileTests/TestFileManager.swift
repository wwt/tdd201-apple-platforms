//
//  TestFileManager.swift
//  WriteToFileTests
//
//  Created by Heather Meadow on 2/2/21.
//

import Foundation

class FileManager: Foundation.FileManager {
    override func contents(atPath path: String) -> Data? {
        return super.contents(atPath: path)
    }
    
    override func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]? = nil) -> Bool {
        return super.createFile(atPath: path, contents: data, attributes: attr)
    }
}
