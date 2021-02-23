//
//  HikeViewTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/23/21.
//

import Foundation
import XCTest
import SwiftUI

@testable import ViewInspector

@testable import SwiftUIExample

extension HikeView: Inspectable { }

class HikeViewTests: XCTestCase {

    func testHikeView() throws {
        let hike = try getHikes().first!
        let exp = ViewHosting.loadView(HikeView(hike: hike)).inspection.inspect { (view) in
            let hikeGraph = try view.find(HikeGraph.self)
            XCTAssertEqual(try hikeGraph.actualView().hike, hike)
            XCTAssertEqual(try hikeGraph.actualView().path, \.elevation)
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 0).string(), hike.name)
            XCTAssertEqual(try view.find(ViewType.Text.self, index: 1).string(), hike.distanceText)
        }

        wait(for: [exp], timeout: 0.1)
    }

    private func getHikes() throws -> [Hike] {
        let file = Bundle.main.url(forResource: "hikeData", withExtension: "json")!
        let data = try Data(contentsOf: file)
        return try JSONDecoder().decode([Hike].self, from: data)
    }
}

extension InspectableView {
    func find<T>(_ viewType: T.Type,
                 index: UInt,
                 where condition: (InspectableView<T>) throws -> Bool = { _ in true }
    ) throws -> InspectableView<T> where T: KnownViewType {
        var matchedCount = 0
        do {
            let view = try find(where: { view -> Bool in
                guard let typedView = try? view.asInspectableView(ofType: T.self)
                else { return false }
                let matched = (try? condition(typedView)) == true
                defer { if matched { matchedCount += 1 } }
                return matched && matchedCount == index
            })
            return try view.asInspectableView(ofType: T.self)
        } catch {
            throw InspectionError.viewIndexOutOfBounds(index: Int(index), count: matchedCount)
        }
    }
}
