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
    
    mutating func getUsers() -> [User] {
        return Array(database!.objects(User.self))
    }
}
