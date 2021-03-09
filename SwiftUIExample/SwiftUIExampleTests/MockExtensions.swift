//
//  MockExtensions.swift
//  MockingFrameworkTests
//
//  Created by thompsty on 3/2/21.
//

import Foundation
import Cuckoo
import Swinject

extension Mock {
    @discardableResult
    func registerIn(_ container: Container) -> Self {
        guard let cast = self as? Self.MocksType else {
            return self
        }
        container.register(MocksType.self) {_ in
            return cast
        }
        return self
    }

    @discardableResult
    func stub(block: (Stubbing) -> Void) -> Self {
        block(getStubbingProxy())
        return self
    }
}
