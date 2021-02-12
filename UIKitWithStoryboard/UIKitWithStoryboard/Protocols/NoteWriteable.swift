//
//  NoteWriteable.swift
//  UIKitWithStoryboard
//
//  Created by Heather Meadow on 2/12/21.
//

import Foundation

protocol NoteWriteable where Contents: FileWriteable {
    associatedtype Contents
    var name: String { get }
    var contents: Contents { get }
}
