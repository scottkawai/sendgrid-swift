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
        settings.bypassListManagement = BypassListManagement()
        settings.footer = Footer(text: "Hello World", html: "<p>Hello World</p>")
        settings.sandboxMode = SandboxMode()
        settings.spamCheck = SpamChecker(threshold: 8)
        let expected: [String : Any] = [
            "bcc": [
                "enable": true,
                "email": "foo@example.none"
            ],
            "bypass_list_management": ["enable": true],
            "footer": [
                "enable": true,
                "text": "Hello World",
                "html": "<p>Hello World</p>"
            ],
            "sandbox_mode": ["enable": true],
            "spam_check": [
                "enable": true,
                "threshold": 8
            ]
        ]
        XCTAssertEncodedObject(settings, equals: expected)
    }
    
}
