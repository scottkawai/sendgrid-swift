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
        settings.bcc = BCCSetting(email: "foo@example.none")
        settings.sandboxMode = SandboxMode()
        let expected: [String : Any] = [
            "bcc": [
                "enable": true,
                "email": "foo@example.none"
            ],
            "sandbox_mode": ["enable": true]
        ]
        XCTAssertEncodedObject(settings, equals: expected)
    }
    
}
