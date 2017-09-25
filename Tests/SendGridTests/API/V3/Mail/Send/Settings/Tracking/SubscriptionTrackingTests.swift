//
//  SubscriptionTrackingTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/17/17.
//

import XCTest
@testable import SendGrid

class SubscriptionTrackingTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = SubscriptionTracking
    
    func testEncoding() {
        let templateSetting = SubscriptionTracking(plainText: "Unsubscribe: <% %>", html: "<% Unsubscribe %>")
        let templateExpectations: [String : Any] = [
            "enable": true,
            "text": "Unsubscribe: <% %>",
            "html": "<% Unsubscribe %>"
        ]
        XCTAssertEncodedObject(templateSetting, equals: templateExpectations)
        
        let subSetting = SubscriptionTracking(substitutionTag: "%unsub%")
        XCTAssertEncodedObject(subSetting, equals: ["enable": true, "substitution_tag": "%unsub%"])
        
        let offSetting = SubscriptionTracking()
        XCTAssertEncodedObject(offSetting, equals: ["enable": false])
    }
    
    func testValidation() {
        let good1 = SubscriptionTracking(
            plainText: "Click here to unsubscribe: <% %>.",
            html: "<p><% Click here %> to unsubscribe.</p>"
        )
        XCTAssertNoThrow(try good1.validate())
        
        let good2 = SubscriptionTracking()
        XCTAssertNoThrow(try good2.validate())
        
        do {
            let missingPlain = SubscriptionTracking(
                plainText: "Click here to unsubscribe",
                html: "<p><% Click here %> to unsubscribe.</p>"
            )
            try missingPlain.validate()
        } catch SendGrid.Exception.Mail.missingSubscriptionTrackingTag {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let missingHTML = SubscriptionTracking(
                plainText: "Click here to unsubscribe: <% %>.",
                html: "<p>Click here to unsubscribe.</p>"
            )
            try missingHTML.validate()
        } catch SendGrid.Exception.Mail.missingSubscriptionTrackingTag {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}
