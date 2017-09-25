//
//  TrackingSettingsTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/16/17.
//

import XCTest
@testable import SendGrid

class TrackingSettingsTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = TrackingSettings
    
    func testEncoding() {
        var settings = TrackingSettings()
        settings.clickTracking = ClickTracking(section: .htmlBody)
        settings.googleAnalytics = GoogleAnalytics(source: "test")
        settings.openTracking = OpenTracking(location: .bottom)
        settings.subscriptionTracking = SubscriptionTracking(substitutionTag: "%unsub%")
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
            ],
            "subscription_tracking": [
                "enable": true,
                "substitution_tag": "%unsub%"
            ]
        ]
        XCTAssertEncodedObject(settings, equals: expected)
    }
    
    func testValidation() {
        var plain = TrackingSettings()
        XCTAssertNoThrow(try plain.validate())
        
        plain.subscriptionTracking = SubscriptionTracking(
            plainText: "Click here to unsubscribe: <% %>.",
            html: "<p><% Click here %> to unsubscribe.</p>"
        )
        
        XCTAssertNoThrow(try plain.validate())
        
        do {
            var subTest = TrackingSettings()
            subTest.subscriptionTracking = SubscriptionTracking(
                plainText: "Click here to unsubscribe.",
                html: "<p><% Click here %> to unsubscribe.</p>"
            )
            try subTest.validate()
        } catch SendGrid.Exception.Mail.missingSubscriptionTrackingTag {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}
