//
//  URLMatcher.swift
//  WriteToFileTests
//
//  Created by thompsty on 2/3/21.
//

import Foundation
import Cuckoo

extension URL: Matchable { }

func anyURL() -> ParameterMatcher<URL> {
    ParameterMatcher<URL>()
}

func anyURL() -> ParameterMatcher<URL?> {
    ParameterMatcher<URL?>()
}
