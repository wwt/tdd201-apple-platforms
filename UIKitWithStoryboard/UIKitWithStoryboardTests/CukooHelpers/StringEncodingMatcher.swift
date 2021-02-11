//
//  StringEncodingMatcher.swift
//  UIKitWithStoryboardTests
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation
import Cuckoo

extension String.Encoding: Matchable { }

func anyStringEncoding() -> ParameterMatcher<String.Encoding> {
    ParameterMatcher<String.Encoding>()
}

func anyStringEncoding() -> ParameterMatcher<String.Encoding?> {
    ParameterMatcher<String.Encoding?>()
}
