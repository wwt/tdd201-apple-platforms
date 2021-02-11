//
//  FileWriteable.swift
//  UIKitWithStoryboard
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation

protocol FileWriteable {
    func write(to: URL, atomically: Bool, encoding: String.Encoding) throws
}

extension String: FileWriteable { }
