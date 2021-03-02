//
//  UIDeviceExtensions.swift
//  SwiftUIExampleUITests
//
//  Created by thompsty on 3/2/21.
//

import Foundation
import UIKit

extension UIDevice {
    var isCorrectSimulatorForSnapshot: Bool {
        return ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] == "iPhone13,4"
    }
}
