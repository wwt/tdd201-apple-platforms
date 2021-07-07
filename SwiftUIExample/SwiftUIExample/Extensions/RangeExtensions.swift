//
//  RangeExtensions.swift
//  SwiftUIExample
//
//  Created by David Roff on 7/7/21.
//

import Foundation

extension Range where Bound: FloatingPoint {
    var magnitude: Bound {
        return upperBound - lowerBound
    }
}
