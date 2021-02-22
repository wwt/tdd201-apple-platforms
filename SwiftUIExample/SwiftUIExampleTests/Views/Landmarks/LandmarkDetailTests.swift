//
//  LandmarkDetailTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/22/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector

@testable import SwiftUIExample

extension LandmarkDetail: Inspectable { }

class LandmarkDetailTests: XCTestCase {

    override func setUpWithError() throws {

    }

    func testLandmarkDetailDisplaysTheThings() throws {
        var landmarkDetail = try LandmarkDetail().inspect()
//        var scrollView = try landmarkDetail.find(ViewType.ScrollView.self)
        // Cannot test MapView yet :'(
//        let image = try scrollView.find(ViewType.Image.self)

    }
}
