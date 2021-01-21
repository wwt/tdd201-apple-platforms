//
//  DateFormatterExtensions.swift
//  CombineWithREST
//
//  Created by thompsty on 1/20/21.
//

import Foundation

extension DateFormatter {
    convenience init(_ format: String) {
        self.init()
        dateFormat = format
    }
}
