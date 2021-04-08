//
//  XCTestAdditions.swift
//  SwiftUIExampleTests
//
//  Created by Richard Gist on 4/8/21.
//

import XCTest

public func XCTAssertNoThrowAndAssign<T>(_ expression: @autoclosure () throws -> T,
                                         _ message: @autoclosure () -> String = "",
                                         file: StaticString = #filePath,
                                         line: UInt = #line) -> T? {
    XCTAssertNoThrow(try expression(), message(), file: file, line: line)

    return try? expression()
}

public func XCTAssertNoThrowAndAssign<T>(_ expression: @autoclosure () throws -> T?,
                                         _ message: @autoclosure () -> String = "",
                                         file: StaticString = #filePath,
                                         line: UInt = #line) -> T? {
    XCTAssertNoThrow(try expression(), message(), file: file, line: line)

    if let expression = try? expression() {
        return expression
    }

    return nil
}
