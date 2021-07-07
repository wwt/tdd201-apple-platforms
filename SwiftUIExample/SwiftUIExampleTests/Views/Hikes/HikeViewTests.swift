//
//  HikeViewTests.swift
//  SwiftUIExampleTests
//
//  Created by David Roff on 7/7/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector

@testable import SwiftUIExample

class HikeViewTests: XCTestCase {
    func testHikeView() throws {
        let hike = try getHikes().first!
        let exp = ViewHosting.loadView(HikeView(hike: hike)).inspection.inspect { (view) in
            let hikeGraph = try view.find(HikeGraph.self)
            let button = try view.find(ViewType.Button.self)

            XCTAssertEqual(try hikeGraph.actualView().hike, hike)
            XCTAssertEqual(try hikeGraph.actualView().path, \.elevation)
            XCTAssertEqual(try view.find(ViewType.Text.self).string(), hike.name)
            XCTAssertEqual(try view.find(ViewType.Text.self, skipFound: 1).string(), hike.distanceText)
            XCTAssertEqual(try button.find(ViewType.Image.self).actualImage(), Image(systemName: "chevron.right.circle"))
        }

        wait(for: [exp], timeout: 3.0)
    }

    func testHikeViewShowsDetails() throws {
        let hike = try getHikes().first!
        let exp = ViewHosting.loadView(HikeView(hike: hike)).inspection.inspect { (view) in
            let button = try view.find(ViewType.Button.self)

            XCTAssertThrowsError(try view.find(HikeDetail.self))
            XCTAssertEqual(try button.find(ViewType.Image.self).scaleEffect(), CGSize(width: 1.0, height: 1.0))
            XCTAssertEqual(try button.find(ViewType.Image.self).rotation().angle, Angle.degrees(0))

            try button.tap()

            XCTAssertEqual(try view.find(HikeDetail.self).actualView().hike, hike)
            XCTAssertEqual(try view.find(ViewType.Button.self).find(ViewType.Image.self).scaleEffect(), CGSize(width: 1.5, height: 1.5))
            XCTAssertEqual(try view.find(ViewType.Button.self).find(ViewType.Image.self).rotation().angle, Angle.degrees(90))
        }

        wait(for: [exp], timeout: 3.0)
    }

    private func getHikes() throws -> [Hike] {
        return try JSONDecoder().decode([Hike].self, from: hikesJson)
    }
}
