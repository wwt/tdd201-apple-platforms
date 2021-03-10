//
//  HikeDetailTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/23/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector

@testable import SwiftUIExample

class HikeDetailTests: XCTestCase {
    func testHikeDetail() throws {
        let hike = try getHikes().first!
        let exp = ViewHosting.loadView(HikeDetail(hike: hike)).inspection.inspect { (view) in
            let hikeGraph = try view.find(HikeGraph.self)

            XCTAssertEqual(try hikeGraph.actualView().hike, hike)
            XCTAssertEqual(try hikeGraph.actualView().path, \Hike.Observation.elevation)
            XCTAssertEqual(try view.find(ViewType.ForEach.self).count, 3)
            try view.find(ViewType.ForEach.self).enumerated().forEach {
                let button = try $0.element.find(ViewType.Button.self)
                let expectedColor = try view.actualView().buttons[$0.offset].1 == \Hike.Observation.elevation ? Color.gray : Color.accentColor
                XCTAssertEqual(try button.labelView().find(ViewType.Text.self).string(), try view.actualView().buttons[$0.offset].0)
                XCTAssertEqual(try button.labelView().find(ViewType.Text.self).attributes().foregroundColor(), expectedColor)
            }
        }
        wait(for: [exp], timeout: 3.0)
    }

    func testTappingButtonTogglesData() throws {
        let hike = try getHikes().first!
        let exp = ViewHosting.loadView(HikeDetail(hike: hike)).inspection.inspect { (hikeDetail) in
            let elevationButton = try hikeDetail.find(button: "Elevation")
            let heartRateButton = try hikeDetail.find(button: "Heart Rate")
            let paceButton = try hikeDetail.find(button: "Pace")

            try elevationButton.tap()
            XCTAssertEqual(try hikeDetail.actualView().dataToShow, \Hike.Observation.elevation)
            XCTAssertEqual(try hikeDetail.find(HikeGraph.self).actualView().path, \Hike.Observation.elevation)

            try heartRateButton.tap()
            XCTAssertEqual(try hikeDetail.actualView().dataToShow, \Hike.Observation.heartRate)
            XCTAssertEqual(try hikeDetail.find(HikeGraph.self).actualView().path, \Hike.Observation.heartRate)

            try paceButton.tap()
            XCTAssertEqual(try hikeDetail.actualView().dataToShow, \Hike.Observation.pace)
            XCTAssertEqual(try hikeDetail.find(HikeGraph.self).actualView().path, \Hike.Observation.pace)
        }
        wait(for: [exp], timeout: 3.0)
    }

    private func getHikes() throws -> [Hike] {
        return try JSONDecoder().decode([Hike].self, from: hikesJson)
    }
}
