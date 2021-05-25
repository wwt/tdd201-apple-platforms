//
//  CategoryHomeTests.swift
//  SwiftUIExampleTests
//
//  Created by Zach Frew on 5/21/21.
//

import SwiftUI
import ViewInspector
import XCTest

@testable import SwiftUIExample

class CategoryHomeTests: XCTestCase {
    func testCategoryHome() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let exp = ViewHosting.loadView(CategoryHome(), data: appModel).inspection.inspect { categoryHome in
            let navView = XCTAssertNoThrowAndAssign(try categoryHome.find(ViewType.NavigationView.self))
            let list = XCTAssertNoThrowAndAssign(try navView?.find(ViewType.List.self))
            let featuredImage = XCTAssertNoThrowAndAssign(try list?.find(ViewType.Image.self))

            XCTAssertNotNil(appModel.features.first)
            XCTAssertEqual(try featuredImage?.actualImage(), appModel.features.first?.image.resizable())

            let forEach = XCTAssertNoThrowAndAssign(try list?.find(ViewType.ForEach.self))

            XCTAssertEqual(forEach?.count, appModel.categories.count)

            let sortedCategories = appModel.categories.sorted { $0.key < $1.key }
            try forEach?.enumerated().forEach { offset, element in
                let categoryRow = XCTAssertNoThrowAndAssign(try element.view(CategoryRow.self))

                XCTAssertEqual(try categoryRow?.actualView().name, sortedCategories[offset].key)
                XCTAssertEqual(try categoryRow?.actualView().items, sortedCategories[offset].value)

            }
        }
        wait(for: [exp], timeout: 0.5)
    }

    func testWhenDragGestureThenShowSheet() throws {
        let appModel = AppModel()
        appModel.landmarks = try JSONDecoder().decode([Landmark].self, from: landmarksJson)

        let exp = ViewHosting.loadView(CategoryHome(), data: appModel).inspection.inspect { categoryHome in
            let gesture = XCTAssertNoThrowAndAssign(try categoryHome.navigationView().gesture(DragGesture.self))
            let gestureValue = DragGesture.Value(time: Date(), location: .zero, startLocation: CGPoint(x: 0, y: 10), velocity: .zero)
            try gesture?.callOnChanged(value: gestureValue)
            let sheet = XCTAssertNoThrowAndAssign(try categoryHome.find(ViewType.Sheet.self))
            XCTAssertNoThrow(try sheet?.view(ProfileHost.self))
        }
        wait(for: [exp], timeout: 0.5)
    }
}
