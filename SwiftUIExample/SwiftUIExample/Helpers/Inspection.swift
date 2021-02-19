//
//  Inspection.swift
//  SwiftUIExample
//
//  Created by Heather Meadow on 2/19/21.
//

import Combine
import SwiftUI

internal final class Inspection<V> where V: View {

    let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (V) -> Void]()

    func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}
