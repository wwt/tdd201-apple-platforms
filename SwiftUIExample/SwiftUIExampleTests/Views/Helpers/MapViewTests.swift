//
//  MapViewTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 3/1/21.
//

import Foundation
import XCTest
import SwiftUI
import CoreLocation
import ViewInspector
import SnapshotTesting

@testable import SwiftUIExample

class MapViewTests: XCTestCase {
    // ViewInspector does not currently support Map() - 03/01/21
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        let view = MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
        assertSnapshot(matching: view, as: .dump)
    }
}
