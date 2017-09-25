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
        let on = BypassListManagement(enable: true)
        XCTAssertEncodedObject(on, equals: ["enable": true])
        
        let off = BypassListManagement(enable: false)
        XCTAssertEncodedObject(off, equals: ["enable": false])
        
        let unspecified = BypassListManagement()
        XCTAssertEncodedObject(unspecified, equals: ["enable": true])
    }
    
}
