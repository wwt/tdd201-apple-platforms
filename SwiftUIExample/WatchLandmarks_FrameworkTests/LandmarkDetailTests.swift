//
//  LandmarkDetailTests.swift
//  WatchLandmarks_FrameworkTests
//
//  Created by thompsty on 4/6/21.
//

import Foundation
import XCTest
import ViewInspector

@testable import WatchLandmarks_Framework // except this is really the watch extension in disguise

class LandmarkDetailTests: XCTestCase {
    func testLandmarkDetailDisplaysTheThings() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let expectedLandmark = appModel.landmarks[0]

        let exp = ViewHosting.loadView(LandmarkDetail(landmark: expectedLandmark), data: appModel).inspection.inspect { (view) in
            let circleImage = try view.find(CircleImage.self)
            XCTAssertEqual(try circleImage.actualView().image, expectedLandmark.image.resizable())
        }

        wait(for: [exp], timeout: 3.0)
    }
}
