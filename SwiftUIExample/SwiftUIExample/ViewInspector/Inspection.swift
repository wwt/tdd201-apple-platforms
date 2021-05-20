//
//  Inspection.swift
//  SwiftUIExample
//
//  Created by david.roff on 5/20/21.
//

import SwiftUI
import Combine
final class Inspection<V> where V: View {
    let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (V)->Void]()
    func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}
