//
//  URLMatcher.swift
//  UIKitWithStoryboardTests
//
//  Created by Heather Meadow on 2/10/21.
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
