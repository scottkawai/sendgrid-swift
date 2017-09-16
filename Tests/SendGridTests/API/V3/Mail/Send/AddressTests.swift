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
    
}
