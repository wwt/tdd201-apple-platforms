//
//  GraphCapsuleTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/23/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector

@testable import SwiftUIExample

class GraphCapsuleTests: XCTestCase {

    func testGraphCapsule() throws {
        let graphCapsule = GraphCapsule(index: 0, height: 1.0, range: 1..<20, overallRange: 3..<23)

        let capsule = try graphCapsule.inspect().shape()

        XCTAssertEqual(try capsule.fixedHeight(), 0.95)
    }
}
