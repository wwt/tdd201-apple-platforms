//
//  RangeExtensions.swift
//  SwiftUIExample
//
//  Created by thompsty on 3/8/21.
//

import Foundation

extension Range where Bound: FloatingPoint {
    var magnitude: Bound {
        return upperBound - lowerBound
    }
}
