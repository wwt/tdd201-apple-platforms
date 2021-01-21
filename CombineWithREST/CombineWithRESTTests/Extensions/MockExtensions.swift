//
//  MockExtensions.swift
//  CombineWithRESTTests
//
//  Created by thompsty on 1/20/21.
//

import Foundation
import Cuckoo
import Swinject

extension Mock {
    @discardableResult
    func registerIn(container: Container) -> Self {
        guard let cast = self as? Self.MocksType else {
            return self
        }
        container.register(MocksType.self) {_ in
            return cast
        }
        return self
    }
}
