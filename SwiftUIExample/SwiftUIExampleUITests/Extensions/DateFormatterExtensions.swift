//
//  DateFormatterExtensions.swift
//  SwiftUIExampleUITests
//
//  Created by Heather Meadow on 3/8/21.
//

import Foundation

extension DateFormatter {
    public convenience init(_ format: String) {
        self.init()
        dateFormat = format
    }
}
