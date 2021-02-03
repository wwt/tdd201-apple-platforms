//
//  StringEncodingMatcher.swift
//  WriteToFileTests
//
//  Created by thompsty on 2/3/21.
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
