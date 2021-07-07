//
//  GraphCapsuleTests.swift
//  SwiftUIExampleTests
//
//  Created by David Roff on 7/7/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector

@testable import SwiftUIExample

class GraphCapsuleTests: XCTestCase {
    #warning("Need to test height ratio and offset ratio")

    func testGraphCapsule() throws {
        let graphCapsule = GraphCapsule(index: 0, height: 1.0, range: 1..<20, overallRange: 3..<23)

        XCTAssertEqual(try graphCapsule.inspect().shape().fixedHeight(), 0.95)
        XCTAssertEqual(try graphCapsule.inspect().shape().offset(), CGSize(width: 0.0, height: 0.1))
    }
}
