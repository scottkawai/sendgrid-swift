//
//  BCCSettingTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/16/17.
//

import XCTest
@testable import SendGrid

class BCCSettingTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = BCCSetting
    
    func testEncoding() {
        let setting = BCCSetting(email: "foo@example.none")
        XCTAssertEncodedObject(setting, equals: ["enable": true, "email": "foo@example.none"])
        
        let offSetting = BCCSetting()
        XCTAssertEncodedObject(offSetting, equals: ["enable": false])
        
        let address = Address(email: "foo@example.none")
        let withAddress = BCCSetting(address: address)
        XCTAssertEncodedObject(withAddress, equals: ["enable": true, "email": "foo@example.none"])
    }
    
    func testValidation() {
        let good = BCCSetting(email: "test@example.com")
        XCTAssertNoThrow(try good.validate())
        
        do {
            let bad = BCCSetting(email: "test")
            try bad.validate()
            XCTFail("Expected a failure when initializing the BCC setting with a malformed email, but no error was thrown.")
        } catch SendGrid.Exception.Mail.malformedEmailAddress(let em) {
            XCTAssertEqual(em, "test")
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}
