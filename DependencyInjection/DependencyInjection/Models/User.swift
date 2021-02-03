//
//  User.swift
//  DependencyInjection
//
//  Created by Heather Meadow on 2/1/21.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var id: Int
    @objc dynamic var firstName: String
    @objc dynamic var lastName: String

    override init() {
        id = 0
        firstName = ""
        lastName = ""
    }

    init(id: Int, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}
