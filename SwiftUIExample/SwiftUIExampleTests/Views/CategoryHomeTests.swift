//
//  CategoryHomeTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/19/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector

@testable import SwiftUIExample

extension Inspection: InspectionEmissary where V: Inspectable { }
extension CategoryHome: Inspectable { }

class CategoryHomeTests: XCTestCase {

    override func setUpWithError() throws {

    }

    func testCategoryHomeHasNavigationView() throws {
        let exp = loadView(with: ModelData()).inspection.inspect { (view) in
            _ = try view.navigationView()
        }

        wait(for: [exp], timeout: 0.1)

    }

    func testCategoryHomeDisplaysCategoriesOfLandmarks() throws {
        let file = Bundle.main.url(forResource: "landmarkData", withExtension: "json")!
        let data = try Data(contentsOf: file)
        let modelData = ModelData()
        modelData.landmarks = try JSONDecoder().decode([Landmark].self, from: data)

        let exp = loadView(with: modelData).inspection.inspect { (view) in
            let list = try view.navigationView().list(0)
            try list.forEach(0).enumerated().forEach {
                let row = try $0.element.find(CategoryRow.self).actualView()
                let expectedKey = modelData.categories.keys.sorted()[$0.offset]
                XCTAssertEqual(row.categoryName, expectedKey)
                XCTAssertEqual(row.items, modelData.categories[expectedKey])
            }
        }

        wait(for: [exp], timeout: 0.1)

    }

    private func loadView<T: ObservableObject>(with data: T) -> CategoryHome {
        let categoryHome = CategoryHome()
        defer {
            ViewHosting.host(view: categoryHome.environmentObject(data))
        }
        return categoryHome
    }
}
