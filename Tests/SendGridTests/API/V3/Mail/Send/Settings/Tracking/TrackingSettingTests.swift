//
//  TrackingSettingTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/16/17.
//

import XCTest
@testable import SendGrid

class TrackingSettingTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = TrackingSetting
    
    func testEncoding() {
        var settings = TrackingSetting()
        settings.clickTracking = ClickTracking(section: .htmlBody)
        let expected: [String : Any] = [
            "click_tracking": [
                "enable": true,
                "enable_text": false
            ]
        ]
        XCTAssertEncodedObject(settings, equals: expected)
    }
    
}
