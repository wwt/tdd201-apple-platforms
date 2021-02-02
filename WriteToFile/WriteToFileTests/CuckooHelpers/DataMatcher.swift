//
//  DataMatcher.swift
//  WriteToFileTests
//
//  Created by thompsty on 2/2/21.
//

import Foundation
import Cuckoo

extension Data: OptionalMatchable {
    public typealias OptionalMatchedType = Data
}

func anyData() -> ParameterMatcher<Data> {
    return ParameterMatcher<Data>()
}

func anyData() -> ParameterMatcher<Data?> {
    return ParameterMatcher<Data?>()
}
