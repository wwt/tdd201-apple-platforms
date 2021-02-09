//
//  DateFormatterExtensionsTests.swift
//  CombineWithRESTTests
//
//  Created by Heather Meadow on 2/8/21.
//

import Foundation
import XCTest

@testable import CombineWithREST

class DateFormatterExtensionsTests: XCTestCase {
    
    
    func testDateFormatterCanBeInitialzedWithAFormat() throws {
        let format = "dd/MM/yyy"
        
        let dateFormatter = DateFormatter(format)
        
        XCTAssertEqual(dateFormatter.dateFormat, format)
    }

}
