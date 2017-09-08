//
//  AuthenticationTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/8/17.
//

import XCTest
@testable import SendGrid

class AuthenticationTests: XCTestCase {
    func testInitializer() {
        let auth = Authentication(prefix: "Bearer", value: "SG.123.ABC", description: "Test")
        XCTAssertEqual(auth.prefix, "Bearer")
        XCTAssertEqual(auth.value, "SG.123.ABC")
        XCTAssertEqual(auth.description, "Test")
    }
    
    func testAuthorizationHeader() {
        let auth = Authentication(prefix: "Bearer", value: "SG.123.ABC", description: "Test")
        XCTAssertEqual(auth.authorizationHeader, "Bearer SG.123.ABC")
    }
    
    func testApiKey() {
        let auth: Authentication = .apiKey("SG.123.ABC")
        XCTAssertEqual(auth.authorizationHeader, "Bearer SG.123.ABC")
    }
    
    func testCredential() {
        let auth: Authentication? = try? .credential(username: "foo", password: "bar")
        XCTAssertEqual(auth?.authorizationHeader, "Basic Zm9vOmJhcg==")
    }
}
