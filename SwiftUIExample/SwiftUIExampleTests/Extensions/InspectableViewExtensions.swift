//
//  InspectableViewExtensions.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/25/21.
//

import Foundation
import SwiftUI

@testable import ViewInspector

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

    func find<V>(_ inspectable: V.Type,
                 index: UInt,
                 where condition: (InspectableView<ViewType.View<V>>) throws -> Bool = { _ in true }
    ) throws -> InspectableView<ViewType.View<V>> where V: Inspectable {
        return try find(ViewType.View<V>.self, index: index, where: condition)
    }
}
