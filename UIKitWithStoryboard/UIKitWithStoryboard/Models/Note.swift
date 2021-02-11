//
//  Note.swift
//  UIKitWithStoryboard
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation

protocol NoteWriteable where Contents: FileWriteable {
    associatedtype Contents
    var name: String { get }
    var contents: Contents { get }
}

struct Note: NoteWriteable {
    let name: String
    let contents: String
}
