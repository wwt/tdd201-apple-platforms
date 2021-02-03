//
//  FileWriteable.swift
//  WriteToFile
//
//  Created by thompsty on 2/3/21.
//

import Foundation

protocol FileWriteable {
    func write(to: URL, atomically: Bool, encoding: String.Encoding) throws
}

extension String: FileWriteable { }
