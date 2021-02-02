//
//  UserService.swift
//  DependencyInjection
//
//  Created by Heather Meadow on 2/1/21.
//

import Foundation
import RealmSwift

struct UserService {
    @DependencyInjected var database:Realm?
    
    mutating func getUsers() throws -> [User] {
        guard let database = database else {
            throw DatabaseError.connectionFailure
        }
        return Array(database.objects(User.self))
    }
}

extension UserService {
    enum DatabaseError: Error {
        case connectionFailure
    }
}
