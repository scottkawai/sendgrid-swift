//
//  BypassListManagementTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/16/17.
//

import XCTest
@testable import SendGrid

class BypassListManagementTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = BypassListManagement
    
    func testEncoding() {
        let setting = BypassListManagement()
        XCTAssertEncodedObject(setting, equals: ["enable": true])
    }
    
}
