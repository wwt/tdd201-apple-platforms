//
//  InspectableSheet.swift
//  SwiftUIExample
//
//  Created by david.roff on 5/25/21.
//

import Foundation
import SwiftUI

extension View {
    func testableSheet<Sheet>(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Sheet
    ) -> some View where Sheet: View {
        modifier(InspectableSheet(isPresented: isPresented, onDismiss: onDismiss, content: content))
    }
}

struct InspectableSheet<Sheet>: ViewModifier where Sheet: View {
    let isPresented: Binding<Bool>
    let onDismiss: (() -> Void)?
    let content: () -> Sheet
    let sheetBuilder: () -> Any

    init(isPresented: Binding<Bool>, onDismiss: (() -> Void)?, content: @escaping () -> Sheet) {
        self.isPresented = isPresented
        self.onDismiss = onDismiss
        self.content = content
        self.sheetBuilder = { content() as Any }
    }

    func body(content: Self.Content) -> some View {
        content.sheet(isPresented: isPresented, content: self.content)
    }
}
