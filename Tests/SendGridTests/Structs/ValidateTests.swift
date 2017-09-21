//
//  ValidateTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/8/17.
//

import XCTest
@testable import SendGrid

class ValidateTests: XCTestCase {
    
    func testInput() {
        let pass = Validate.input("Hello World", against: "World")
        let fail = Validate.input("Hello World", against: "Foo")
        XCTAssertTrue(pass)
        XCTAssertFalse(fail)
        
        let badPattern = Validate.input("(", against: "(")
        XCTAssertFalse(badPattern)
    }
    
    func testEmail() {
        for goodEmail in ["foo@example.none", "foo@example.co.none"] {
            XCTAssertTrue(Validate.email(goodEmail), "'\(goodEmail)' validates successfully")
        }
        for badEmail in ["example.none", "foo@example"] {
            XCTAssertFalse(Validate.email(badEmail), "'\(badEmail)' fails validation")
        }
    }
    
    func testSubscriptionTracking() {
        let valid = [
            "To unsubscribe, <% click here %>.",
            "To unsubscribe, <% click here%>."
        ]
        let invalid = [
            "To unsubscribe, click here.",
            "To unsubscribe, <%click here %>."
        ]
        for body in valid {
            XCTAssertTrue(Validate.subscriptionTracking(body: body), body)
        }
        for body in invalid {
            XCTAssertFalse(Validate.subscriptionTracking(body: body), body)
        }
    }
    
    func testNoCLRF() {
        for input in ["foo", "foo/bar"] {
            XCTAssertTrue(Validate.noCLRF(in: input), "'\(input)' validates successfully")
        }
        for input in ["foo bar", "foo;bar", "foo,bar", ""] {
            XCTAssertFalse(Validate.noCLRF(in: input), "'\(input)' fails validation")
        }
    }
    
}
