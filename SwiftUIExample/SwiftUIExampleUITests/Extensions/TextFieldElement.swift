//
//  TextFieldElement.swift
//  SwiftUIExampleUITests
//
//  Created by Heather Meadow on 3/8/21.
//

import Foundation
import XCTest

extension XCUIElement {
    var textFieldElement: TextFieldElement? {
        TextFieldElement(with: self)
    }
}

struct TextFieldElement {
    let wrapped: XCUIElement
    private let stringValue: String

    init?(with element: XCUIElement) {
        guard let value = element.value as? String else { return nil }
        wrapped = element
        stringValue = value
    }

    func clearText() {
        // workaround for apple bug
        if let placeholderString = wrapped.placeholderValue, placeholderString == stringValue {
            return
        }
        wrapped.tap()
        let deleteText = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        wrapped.typeText(deleteText)
    }

    func clearAndEnterText(_ text: String) {
        clearText()
        wrapped.tap()
        wrapped.typeText(text)
    }
}
