//
//  UserServiceTests.swift
//  DependencyInjectionTests
//
//  Created by Heather Meadow on 2/1/21.
//

import Foundation
import XCTest
import RealmSwift
import Swinject

@testable import DependencyInjection

class UserServiceTests: XCTestCase {
    var testObject:UserService!
    
    override func setUpWithError() throws {
        testObject = UserService()
        Container.default.removeAll()
    }
    
    func testServiceCanGetAllUsers() throws {
        let user1 = User(id: 1, firstName: UUID().uuidString, lastName: UUID().uuidString)
        let user2 = User(id: 2, firstName: UUID().uuidString, lastName: UUID().uuidString)
        let realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "UserServiceTests"))
        try realm.write {
            realm.add([user1, user2])
        }
        
        Container.default.register(Realm.self) { _ in realm }
        
        let users = testObject.getUsers()
    
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users.first?.id, user1.id)
        XCTAssertEqual(users.first?.firstName, user1.firstName)
        XCTAssertEqual(users.first?.lastName, user1.lastName)
        XCTAssertEqual(users.last?.id, user2.id)
        XCTAssertEqual(users.last?.firstName, user2.firstName)
        XCTAssertEqual(users.last?.lastName, user2.lastName)
    }
}
