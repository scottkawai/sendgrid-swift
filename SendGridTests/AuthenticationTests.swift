//
//  AuthenticationTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/9/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest

class AuthenticationTests: XCTestCase {
    
    let credential = Authentication.Credential(username: "foo", password: "bar")
    let apiKey = Authentication.ApiKey("06A9D906-8B40-49A8-AF9A-46EB9723EDDA")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        let cred = Authentication(info: ["username":"foo", "password":"bar"])
        XCTAssertNotNil(cred)
        XCTAssertEqual(cred?.authorizationHeader, self.credential.authorizationHeader)
        
        let key = Authentication(info: ["api_key":"06A9D906-8B40-49A8-AF9A-46EB9723EDDA"])
        XCTAssertNotNil(key)
        XCTAssertEqual(key?.authorizationHeader, self.apiKey.authorizationHeader)
        
        let bad = Authentication(info: ["foo":"bar"])
        XCTAssertNil(bad)
    }
    
    func testUserProperty() {
        XCTAssertEqual(self.credential.user, "foo")
        XCTAssertNil(self.apiKey.user)
    }
    
    func testKeyProperty() {
        XCTAssertEqual(self.credential.key, "bar")
        XCTAssertEqual(self.apiKey.key, "06A9D906-8B40-49A8-AF9A-46EB9723EDDA")
    }
    
    func testHeader() {
        XCTAssertEqual(self.credential.authorizationHeader, "Basic Zm9vOmJhcg==")
        XCTAssertEqual(self.apiKey.authorizationHeader, "Bearer 06A9D906-8B40-49A8-AF9A-46EB9723EDDA")
    }
    
}
