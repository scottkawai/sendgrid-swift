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
        settings.googleAnalytics = GoogleAnalytics(source: "test")
        settings.openTracking = OpenTracking(location: .bottom)
        let expected: [String : Any] = [
            "click_tracking": [
                "enable": true,
                "enable_text": false
            ],
            "ganalytics": [
                "enable": true,
                "utm_source": "test"
            ],
            "open_tracking": [
                "enable": true
            ]
        ]
        XCTAssertEncodedObject(settings, equals: expected)
    }
    
}
