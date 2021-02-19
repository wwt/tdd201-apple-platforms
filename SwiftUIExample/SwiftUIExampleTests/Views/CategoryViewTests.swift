//
//  CategoryViewTests.swift
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

class CategoryViewTests: XCTestCase {

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
            let categories = try list.forEach(0).map { try $0.text(0).string() }
            XCTAssertEqual(categories, ["Lakes", "Mountains", "Rivers"])
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
