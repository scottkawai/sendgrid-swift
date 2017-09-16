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
        
        let offSetting = BCCSetting(address: nil)
        XCTAssertEncodedObject(offSetting, equals: ["enable": false])
    }
    
}
