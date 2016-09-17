//
//  BCCSettingTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest
@testable import SendGrid

class BCCSettingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        let good = BCCSetting(enable: true, email: Address(emailAddress: "test@example.com"))
        XCTAssertTrue(good.enable)
        XCTAssertEqual(good.email.email, "test@example.com")
        
        do {
            let bad = BCCSetting(enable: false, email: Address(emailAddress: "test"))
            try bad.validate()
            XCTFail("Expected a failure when initializing the BCC setting with a malformed email, but no error was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.malformedEmailAddress("test").description)
        }
    }
    
    func testJSONValue() {
        let bcc = BCCSetting(enable: false, email: Address(emailAddress: "test@example.com"))
        XCTAssertEqual(bcc.jsonValue, "{\"bcc\":{\"email\":\"test@example.com\",\"enable\":false}}")
    }
    
}
