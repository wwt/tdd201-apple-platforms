//
//  ViewHostingExtensions.swift
//  SwiftUIExampleTests
//
//  Created by david.roff on 5/20/21.
//

import Foundation
import SwiftUI
import ViewInspector

extension ViewHosting {
    static func loadView<V: View>(_ view: V) -> V {
        defer {
            Self.host(view: view)
        }
        return view
    }

    static func loadView<V: View, O: ObservableObject>(_ view: V, data: O) -> V {
        defer {
            Self.host(view: view.environmentObject(data))
        }
        return view
    }

    static func loadView<V: View, O: ObservableObject, E>(_ view: V, data: O, keyPath: WritableKeyPath<EnvironmentValues, E>, keyValue: E) -> V {
        defer {
            Self.host(view: view.environmentObject(data).environment(keyPath, keyValue))
        }
        return view
    }
}
