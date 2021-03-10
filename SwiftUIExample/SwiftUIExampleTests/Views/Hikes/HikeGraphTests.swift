//
//  HikeGraphTests.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/23/21.
//

import Foundation
import XCTest
import SwiftUI
import ViewInspector

@testable import SwiftUIExample

class HikeGraphTests: XCTestCase {
    func testHikeGraph() throws {
        let expectedHike = try getHikes().first!
        let observationKeyPath: KeyPath<Hike.Observation, Range<Double>> = \.elevation

        let hikeGraph = HikeGraph(hike: expectedHike, path: observationKeyPath)
        let geometryReader = try hikeGraph.inspect().geometryReader(0)

        XCTAssertEqual(try geometryReader.hStack().forEach(0).count, expectedHike.observations.count)
        try geometryReader.hStack().forEach(0).enumerated().forEach {
            let graphCapsule = try $0.element.find(GraphCapsule.self)
            XCTAssertEqual(try graphCapsule.colorMultiply(), .gray)
            XCTAssertEqual(try graphCapsule.actualView().index, $0.offset)
            let expectedObservation = expectedHike.observations[$0.offset].elevation
            XCTAssertEqual(try graphCapsule.actualView().range, expectedObservation)
            XCTAssertEqual(try graphCapsule.actualView().overallRange, 291.6526363563627..<547.4953522425105)
        }
    }

    func testHighGraphSetsColorBasedOnPath() throws {
        let expectedHike = try getHikes().first!
        var hikeGraph = HikeGraph(hike: expectedHike, path: \.heartRate)
        try hikeGraph.inspect().geometryReader(0).hStack().forEach(0).forEach {
            XCTAssertEqual(try $0.find(GraphCapsule.self).colorMultiply(), Color(hue: 0, saturation: 0.5, brightness: 0.7))
        }

        hikeGraph = HikeGraph(hike: expectedHike, path: \.pace)
        try hikeGraph.inspect().geometryReader(0).hStack().forEach(0).forEach {
            XCTAssertEqual(try $0.find(GraphCapsule.self).colorMultiply(), Color(hue: 0.7, saturation: 0.4, brightness: 0.7))
        }

        hikeGraph = HikeGraph(hike: expectedHike, path: \.newRange)
        try hikeGraph.inspect().geometryReader(0).hStack().forEach(0).forEach {
            XCTAssertEqual(try $0.find(GraphCapsule.self).colorMultiply(), .black)
        }
    }

    private func getHikes() throws -> [Hike] {
        return try JSONDecoder().decode([Hike].self, from: hikesJson)
    }
}

fileprivate extension Hike.Observation {
    var newRange: Range<Double> { 0..<1 }
}
