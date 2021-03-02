//
//  HikeViewTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/23/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector
import SnapshotTesting

@testable import SwiftUIExample

class HikeViewTests: XCTestCase {
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        let hike = try getHikes().first!
        let view = HikeView(hike: hike)
        assertSnapshot(matching: view, as: .image(precision: 0.99))
    }

    func testHikeView() throws {
        let hike = try getHikes().first!
        let exp = ViewHosting.loadView(HikeView(hike: hike)).inspection.inspect { (view) in
            let hikeGraph = try view.find(HikeGraph.self)
            let button = try view.find(ViewType.Button.self, index: 0)

            XCTAssertEqual(try hikeGraph.actualView().hike, hike)
            XCTAssertEqual(try hikeGraph.actualView().path, \.elevation)
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 0).string(), hike.name)
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 1).string(), hike.distanceText)
            XCTAssertEqual(try button.find(ViewType.Image.self).actualImage(), Image(systemName: "chevron.right.circle"))
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testHikeViewShowsDetails() throws {
        let hike = try getHikes().first!
        let exp = ViewHosting.loadView(HikeView(hike: hike)).inspection.inspect { (view) in
            let button = try view.find(ViewType.Button.self, index: 0)

            XCTAssertThrowsError(try view.find(HikeDetail.self))
            XCTAssertEqual(try button.find(ViewType.Image.self).scaleEffect(), CGSize(width: 1.0, height: 1.0))
            XCTAssertEqual(try button.find(ViewType.Image.self).rotation().angle, Angle.degrees(0))

            try button.tap()

            XCTAssertEqual(try view.find(HikeDetail.self).actualView().hike, hike)
            XCTAssertEqual(try view.find(ViewType.Button.self, index: 0).find(ViewType.Image.self).scaleEffect(), CGSize(width: 1.5, height: 1.5))
            XCTAssertEqual(try view.find(ViewType.Button.self, index: 0).find(ViewType.Image.self).rotation().angle, Angle.degrees(90))
        }

        wait(for: [exp], timeout: 0.1)
    }

    private func getHikes() throws -> [Hike] {
        let file = Bundle.main.url(forResource: "hikeData", withExtension: "json")!
        let data = try Data(contentsOf: file)
        return try JSONDecoder().decode([Hike].self, from: data)
    }
}
