//
//  SandboxModeTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/15/17.
//

import XCTest
@testable import SendGrid

class SandboxModeTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = SandboxMode
    
    func testEncoding() {
        let on = SandboxMode(enable: true)
        XCTAssertEncodedObject(on, equals: ["enable": true])
        
        let off = SandboxMode(enable: false)
        XCTAssertEncodedObject(off, equals: ["enable": false])
        
        let unspecified = SandboxMode()
        XCTAssertEncodedObject(unspecified, equals: ["enable": true])
    }
    
}
