//
//  ContractTests.swift
//  CombineWithRESTTests
//
//  Created by thompsty on 1/21/21.
//

import Foundation
import XCTest
import PactConsumerSwift
import Fakery
import Combine

@testable import CombineWithREST

class ContractTests: XCTestCase {
    var identityServiceProvider: MockService!
    var ongoingCalls = Set<AnyCancellable>()

    override func setUpWithError() throws {
        identityServiceProvider = MockService(provider: "IdentityService", consumer: "Combine-iOSAPP")
        ongoingCalls.removeAll()
    }

    func testIdentityServiceCanGetProfile() {
        User.accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        let service = API.IdentityService(baseURL: identityServiceProvider.baseUrl)
        let expectedEmail = Faker().internet.email()
        identityServiceProvider.given("A user with the correct ID exists")
            .uponReceiving("A request for the profile information")
            .withRequest(method: .GET,
                         path: "/me",
                         headers: [
                            // swiftlint:disable:next line_length
                            "Authorization": Matcher.term(matcher: "Bearer (.*?)", generate: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"),
                            "Content-Type": "application/json",
                            "Accept": "application/json"
                         ])
            .willRespondWith(status: 200,
                             headers: ["Content-Type": "application/json"],
                             body: [
                                "self": [
                                    "firstName": Matcher.somethingLike("Joe"),
                                    "lastName": Matcher.somethingLike("Blow"),
                                    "email": Matcher.term(matcher: "(.*)@(.*)", generate: expectedEmail),
                                    "dateOfBirth": Matcher.term(matcher: "(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2}):(\\d{2}):(\\d{2})", generate: "1990-03-26T00:00:00"),
                                    "phoneNumber": Matcher.term(matcher: "\\d{10}", generate: "3033033333"),
                                    "address": [
                                        "line1": Matcher.somethingLike("111 Fake st"),
                                        "line2": Matcher.somethingLike(""),
                                        "city": Matcher.somethingLike("Denver"),
                                        "stateOrProvince": Matcher.somethingLike("CA"),
                                        "zipCode": Matcher.somethingLike("80202"),
                                        "countryCode": "US" // this API is US only, no matcher.
                                    ]
                                ],
                                "isVerified": Matcher.somethingLike(true),
                                "username": Matcher.somethingLike(expectedEmail),
                                "termsAcceptedDate": Matcher.term(matcher: "(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2}):(\\d{2}):(\\d{2})\\.(\\d+)", generate: "2018-07-26T19:33:46.8381401"),
                                "isTermsAccepted": Matcher.somethingLike(true),
                                "createdDate": Matcher.term(matcher: "(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2}):(\\d{2}):(\\d{2})\\.(\\d+)", generate: "2018-07-26T19:33:46.6818918")
                             ])

        identityServiceProvider.run { [self] (testComplete) in
            service.fetchProfile.sink { (res) in
                switch res {
                    case .success(let profile):
                        XCTAssertEqual(profile.firstName, "Joe")
                        XCTAssertEqual(profile.lastName, "Blow")
                        XCTAssertEqual(profile.email, expectedEmail)
                        XCTAssertEqual(profile.dateOfBirth, DateFormatter("yyyy-MM-dd'T'HH:mm:ss").date(from: "1990-03-26T00:00:00"))
                        XCTAssertEqual(profile.address?.line1, "111 Fake st")
                        XCTAssertEqual(profile.address?.line2, "")
                        XCTAssertEqual(profile.address?.city, "Denver")
                        XCTAssertEqual(profile.address?.state, "CA")
                        XCTAssertEqual(profile.address?.zip, "80202")
                        XCTAssert(profile.isVerified, "Profile's isVerified should be true")
                    case .failure(let err): XCTFail(err.localizedDescription)
                }
                testComplete()
            }.store(in: &ongoingCalls)
        }
    }

    func testIdentityServiceCanGetProfile_WithPreferredName() {
        User.accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        let service = API.IdentityService(baseURL: identityServiceProvider.baseUrl)
        let expectedEmail = Faker().internet.email()
        identityServiceProvider.given("A user with a prefferred name and the correct ID exists")
            .uponReceiving("A request for the profile information")
            .withRequest(method: .GET,
                         path: "/me",
                         headers: [
                            // swiftlint:disable:next line_length
                            "Authorization": Matcher.term(matcher: "Bearer (.*?)", generate: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"),
                            "Content-Type": "application/json",
                            "Accept": "application/json"
                         ])
            .willRespondWith(status: 200,
                             headers: ["Content-Type": "application/json"],
                             body: [
                                "self": [
                                    "firstName": Matcher.somethingLike("Joe"),
                                    "lastName": Matcher.somethingLike("Blow"),
                                    "preferredName": Matcher.somethingLike("Joey"),
                                    "email": Matcher.term(matcher: "(.*)@(.*)", generate: expectedEmail),
                                    "dateOfBirth": Matcher.term(matcher: "(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2}):(\\d{2}):(\\d{2})", generate: "1990-03-26T00:00:00"),
                                    "phoneNumber": Matcher.term(matcher: "\\d{10}", generate: "3033033333"),
                                    "address": [
                                        "line1": Matcher.somethingLike("111 Fake st"),
                                        "line2": Matcher.somethingLike(""),
                                        "city": Matcher.somethingLike("Denver"),
                                        "stateOrProvince": Matcher.somethingLike("CA"),
                                        "zipCode": Matcher.somethingLike("80202"),
                                        "countryCode": "US" // this API is US only, no matcher.
                                    ]
                                ],
                                "isVerified": Matcher.somethingLike(true),
                                "username": Matcher.somethingLike(expectedEmail),
                                "termsAcceptedDate": Matcher.term(matcher: "(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2}):(\\d{2}):(\\d{2})\\.(\\d+)", generate: "2018-07-26T19:33:46.8381401"),
                                "isTermsAccepted": Matcher.somethingLike(true),
                                "createdDate": Matcher.term(matcher: "(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2}):(\\d{2}):(\\d{2})\\.(\\d+)", generate: "2018-07-26T19:33:46.6818918")

                             ])

        identityServiceProvider.run { [self] (testComplete) in
            service.fetchProfile.sink { (res) in
                switch res {
                    case .success(let profile):
                        XCTAssertEqual(profile.firstName, "Joe")
                        XCTAssertEqual(profile.lastName, "Blow")
                        XCTAssertEqual(profile.preferredName, "Joey")
                        XCTAssertEqual(profile.email, expectedEmail)
                        XCTAssertEqual(profile.dateOfBirth, DateFormatter("yyyy-MM-dd'T'HH:mm:ss").date(from: "1990-03-26T00:00:00"))
                        XCTAssertEqual(profile.address?.line1, "111 Fake st")
                        XCTAssertEqual(profile.address?.line2, "")
                        XCTAssertEqual(profile.address?.city, "Denver")
                        XCTAssertEqual(profile.address?.state, "CA")
                        XCTAssertEqual(profile.address?.zip, "80202")
                        XCTAssert(profile.isVerified, "Profile's isVerified should be true")
                    case .failure(let err): XCTFail(err.localizedDescription)
                }
                testComplete()
            }.store(in: &ongoingCalls)
        }
    }
}
