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
        let setting = SandboxMode()
        XCTAssertEncodedObject(setting, equals: ["sandbox_mode": ["enable": true]])
    }
    
}
