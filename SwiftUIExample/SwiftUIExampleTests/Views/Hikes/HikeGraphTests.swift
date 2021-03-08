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
import SnapshotTesting

@testable import SwiftUIExample

class HikeGraphTests: XCTestCase {
    func testUIMatchesSnapshot() throws {
        try XCTSkipUnless(UIDevice.current.isCorrectSimulatorForSnapshot)
        let expectedHike = try getHikes().first!
        let observationKeyPath: KeyPath<Hike.Observation, Range<Double>> = \.elevation
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        let view = HikeGraph(hike: expectedHike, path: observationKeyPath)
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        assertSnapshot(matching: view, as: .image(drawHierarchyInKeyWindow: true,
                                                  precision: 0.99,
                                                  layout: .device(config: .iPhoneXsMax)))
    }

    func testHikeGraph() throws {
        let expectedHike = try getHikes().first!
        let observationKeyPath: KeyPath<Hike.Observation, Range<Double>> = \.elevation

        let hikeGraph = HikeGraph(hike: expectedHike, path: observationKeyPath)
        let geometryReader = try hikeGraph.inspect().geometryReader(0)

        #warning("May need more testing")
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
        let file = Bundle.main.url(forResource: "hikeData", withExtension: "json")!
        let data = try Data(contentsOf: file)
        return try JSONDecoder().decode([Hike].self, from: data)
    }
}

fileprivate extension Hike.Observation {
    var newRange: Range<Double> { 0..<1 }
}
