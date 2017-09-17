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
    
}
