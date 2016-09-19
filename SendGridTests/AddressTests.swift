//
//  AddressTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/13/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest
@testable import SendGrid

class AddressTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        let good = Address(emailAddress: "test@example.com", displayName: "Good Email")
        XCTAssertEqual("test@example.com", good.email)
        XCTAssertEqual("Good Email", good.name)
    }
    
    func testValidation() {
        do {
            let bad = Address(emailAddress: "testexample")
            try bad.validate()
            XCTFail("Initialization should have failed with a bad address, but no error was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.malformedEmailAddress("testexample").description)
        }
    }
    
    func testDictionaryValue() {
        let address1 = Address(emailAddress: "test1@example.com")
        let address2 = Address(emailAddress: "test2@example.com", displayName: "Test Two")
        XCTAssertEqual(address1.dictionaryValue["email"] as? String, "test1@example.com")
        XCTAssertTrue(address1.dictionaryValue["name"] == nil)
        XCTAssertEqual(address2.dictionaryValue["name"] as? String, "Test Two")
    }
    
    func testJSONValue() {
        let address1 = Address(emailAddress: "test1@example.com")
        let address2 = Address(emailAddress: "test2@example.com", displayName: "Test Two")
        XCTAssertEqual(address1.jsonValue, "{\"email\":\"test1@example.com\"}")
        XCTAssertEqual(address2.jsonValue, "{\"name\":\"Test Two\",\"email\":\"test2@example.com\"}")
    }
    
}
