//
//  UIUStoryboardTestable.swift
//  UIKitWithStoryboardTests
//
//  Created by Richard Gist on 3/2/21.
//

import UIUTest
import XCTest

protocol UIUStoryboardTestable where ViewControllerUnderTest: UIViewController {
    associatedtype ViewControllerUnderTest
}
extension UIUStoryboardTestable {
    var storyboardIdentifier: String { String(describing: ViewControllerUnderTest.self) }
    func getViewController() throws -> UIViewController {
        guard let viewController = UIViewController.loadFromStoryboard(identifier: storyboardIdentifier) else {
            throw XCTSkip("\(storyboardIdentifier) does not exist on storyboard")
        }

        return viewController
    }

    func getTypedViewController() throws -> ViewControllerUnderTest {
        guard let viewController: ViewControllerUnderTest = UIViewController.loadFromStoryboard(identifier: storyboardIdentifier) else {
            throw XCTSkip("\(storyboardIdentifier) does not exist on storyboard")
        }

        return viewController
    }
}
