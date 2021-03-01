//
//  LandmarkListTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/22/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector
import SnapshotTesting

@testable import SwiftUIExample

class LandmarkListTests: XCTestCase {

    func testUILooksAsExpected() throws {
        let view = LandmarkList().environmentObject(ModelData())
        assertSnapshot(matching: view, as: .image(precision: 0.99))
    }

    func testLandmarkListDisplaysTheThings() throws {
        let file = Bundle.main.url(forResource: "landmarkData", withExtension: "json")!
        let data = try Data(contentsOf: file)
        let modelData = ModelData()
        modelData.landmarks = try JSONDecoder().decode([Landmark].self, from: data)

        let exp = ViewHosting.loadView(LandmarkList(), data: modelData).inspection.inspect { (view) in
            let list = try view.navigationView().find(ViewType.List.self)
            let toggle = try list.find(ViewType.Toggle.self)

            XCTAssertEqual(try list.find(ViewType.ForEach.self).count, modelData.landmarks.count)
            try list.find(ViewType.ForEach.self).enumerated().forEach {
                let navLink = try $0.element.find(ViewType.NavigationLink.self)
                let landmarkDetail = try navLink.view(LandmarkDetail.self)
                let landmarkRow = try navLink.labelView().find(LandmarkRow.self)
                XCTAssertEqual(try landmarkDetail.actualView().landmark, modelData.landmarks[$0.offset])
                XCTAssertEqual(try landmarkRow.actualView().landmark, modelData.landmarks[$0.offset])
            }

            XCTAssertEqual(try toggle.find(ViewType.Text.self).string(), "Favorites only")
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testLandmarkListTogglesFavorites() throws {
        let file = Bundle.main.url(forResource: "landmarkData", withExtension: "json")!
        let data = try Data(contentsOf: file)
        let modelData = ModelData()
        modelData.landmarks = try JSONDecoder().decode([Landmark].self, from: data)

        let exp = ViewHosting.loadView(LandmarkList(), data: modelData).inspection.inspect { (view) in
            let list = try view.navigationView().find(ViewType.List.self)
            let toggle = try list.find(ViewType.Toggle.self)

            XCTAssertFalse(try toggle.isOn())
            XCTAssertEqual(try list.find(ViewType.ForEach.self).count, modelData.landmarks.count)
            try toggle.tap()
            XCTAssert(try toggle.isOn())
            XCTAssertEqual(try view.navigationView().find(ViewType.List.self).find(ViewType.ForEach.self).count, 3)
        }

        wait(for: [exp], timeout: 0.1)
    }
}
