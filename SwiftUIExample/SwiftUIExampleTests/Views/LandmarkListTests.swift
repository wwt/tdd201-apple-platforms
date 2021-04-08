//
//  LandmarkListTests.swift
//  SwiftUIExampleTests
//
//  Created by Richard Gist on 4/8/21.
//

import SwiftUI
import ViewInspector
import Combine
import Cuckoo
import XCTest

@testable import SwiftUIExample

class LandmarkListTests: XCTestCase {
    func testViewHasExpectedViews() throws {
        MockHikesServiceProtocol().stub { stub in
            when(stub.fetchLandmarks.get).thenReturn(Result.Publisher(.success([])).eraseToAnyPublisher())
        }.registerIn(.default)
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let exp = ViewHosting.loadView(LandmarkList(), environmentObject: appModel).inspection.inspect { view in
            let navigationView = XCTAssertNoThrowAndAssign(try view.find(ViewType.NavigationView.self))
            let list = XCTAssertNoThrowAndAssign(try navigationView?.find(ViewType.List.self))

            XCTAssertNoThrow(try list?.find(ViewType.Toggle.self))
            XCTAssertEqual(try list?.find(ViewType.Toggle.self).find(ViewType.Text.self).string(), "Favorites only")
            XCTAssertEqual(try list?.find(ViewType.ForEach.self).count, appModel.landmarks.count)

            try list?.find(ViewType.ForEach.self).enumerated().forEach { each in
                let navigationLink = XCTAssertNoThrowAndAssign(try each.element.find(ViewType.NavigationLink.self))
                let landmarkDetail = XCTAssertNoThrowAndAssign(try navigationLink?.view(LandmarkDetail.self))
                let landmarkRow = XCTAssertNoThrowAndAssign(try navigationLink?.labelView().find(LandmarkRow.self))

                XCTAssertEqual(try landmarkDetail?.actualView().landmark, appModel.landmarks[each.offset])
                XCTAssertEqual(try landmarkRow?.actualView().landmark, appModel.landmarks[each.offset])
            }
        }
        wait(for: [exp], timeout: 1.5)
    }
}
