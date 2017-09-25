//
//  AddressTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/13/17.
//

import XCTest
@testable import SendGrid

class AddressTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = Address
    
    func testEncoding() {
        let withoutName = Address(email: "foo@example.none")
        let withName = Address(email: "foo@example.none", name: "Foo Bar")
        
        XCTAssertEncodedObject(withoutName, equals: ["email": "foo@example.none"])
        XCTAssertEncodedObject(withName, equals: ["name": "Foo Bar", "email": "foo@example.none"])
    }
    
    func testInitialization() {
        let good = Address(email: "test@example.none", name: "Good Email")
        XCTAssertEqual("test@example.none", good.email)
        XCTAssertEqual("Good Email", good.name)
    }
    
    func testValidation() {
        do {
            let bad = Address(email: "testexample")
            try bad.validate()
            XCTFail("Initialization should have failed with a bad address, but no error was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SendGrid.Exception.Mail.malformedEmailAddress("testexample").description)
        }
    }
    
}
