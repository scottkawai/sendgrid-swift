//
//  MailSettingsTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/15/17.
//

import XCTest
@testable import SendGrid

class MailSettingsTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = MailSettings
    
    func testEncoding() {
        var settings = MailSettings()
        settings.sandboxMode = SandboxMode()
        let expected: [String : Any] = [
            "sandbox_mode": ["enable": true]
        ]
        XCTAssertEncodedObject(settings, equals: expected)
    }
    
}
