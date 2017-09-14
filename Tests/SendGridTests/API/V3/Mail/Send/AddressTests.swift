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
        let withoutName = Address(email: "foo@bar.com")
        let withName = Address(email: "foo@bar.com", name: "Foo Bar")
        
        XCTAssert(encodableObject: withoutName, equals: ["email": "foo@bar.com"])
        XCTAssert(encodableObject: withName, equals: ["name": "Foo Bar", "email": "foo@bar.com"])
    }
    
}
