//
//  InspectableAlert.swift
//  SwiftUIExample
//
//  Created by david.roff on 5/25/21.
//

import Foundation
import SwiftUI

extension View {
    func testableAlert(isPresented: Binding<Bool>, content: @escaping () -> Alert) -> some View {
        modifier(InspectableAlert(isPresented: isPresented, alertBuilder: content))
    }
}

struct InspectableAlert: ViewModifier {
    let isPresented: Binding<Bool>
    let alertBuilder: () -> Alert

    func body(content: Self.Content) -> some View {
        content.alert(isPresented: isPresented, content: alertBuilder)
    }
}
