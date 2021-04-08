//
//  ViewHostingExtensions.swift
//  SwiftUIExampleTests
//
//  Created by Richard Gist on 4/8/21.
//

import SwiftUI
import ViewInspector

extension ViewHosting {
    static func loadView<V: View>(_ view: V) -> V {
        defer {
            Self.host(view: view)
        }

        return view
    }

    static func loadView<V: View, O: ObservableObject>(_ view: V, environmentObject: O) -> V {
        defer {
            Self.host(view: view.environmentObject(environmentObject))
        }

        return view
    }
}
