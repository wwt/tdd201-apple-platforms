//
//  FileManagementHelpers.swift
//  WriteToFileTests
//
//  Created by thompsty on 2/2/21.
//

import Foundation
import Cuckoo

extension Dictionary: OptionalMatchable where Key == FileAttributeKey, Value == Any {
    public var optionalMatcher: ParameterMatcher<[FileAttributeKey : Any]?> {
        ParameterMatcher<[FileAttributeKey: Any]?>()
    }
    
    public typealias OptionalMatchedType = [FileAttributeKey : Any]
}

func anyFileAttributes() -> ParameterMatcher<[FileAttributeKey : Any]> {
    return ParameterMatcher<[FileAttributeKey : Any]>()
}

func anyFileAttributes() -> ParameterMatcher<[FileAttributeKey : Any]?> {
    return ParameterMatcher<[FileAttributeKey : Any]?>()
}
