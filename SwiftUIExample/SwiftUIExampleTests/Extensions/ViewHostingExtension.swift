//
//  ViewHostingExtension.swift
//  SwiftUIExampleTests
//
//  Created by Heather Meadow on 2/23/21.
//

import Foundation
import SwiftUI
import ViewInspector

extension ViewHosting {
    static func loadView<V: View, D: ObservableObject>(_ view: V, data: D) -> V {
        defer {
            ViewHosting.host(view: view.environmentObject(data))
        }
        return view
    }

    static func loadView<V: View>(_ view: V) -> V {
        defer {
            ViewHosting.host(view: view)
        }
        return view
    }
}
