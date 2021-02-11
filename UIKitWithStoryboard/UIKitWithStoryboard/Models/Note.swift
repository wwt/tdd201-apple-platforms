//
//  Note.swift
//  UIKitWithStoryboard
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation

struct Note {
    let name: String
    let contents: String
}

extension Note {
    func writer() -> FileWriteable {
        contents
    }
}
