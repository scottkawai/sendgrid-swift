//
//  GoogleAnalyticsTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/16/17.
//

import XCTest
@testable import SendGrid

class GoogleAnalyticsTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = GoogleAnalytics
    
    func testEncoding() {
        let onSettingMin = GoogleAnalytics(source: "test")
        XCTAssertEncodedObject(onSettingMin, equals: ["enable": true, "utm_source": "test"])
        
        let onSettingMax = GoogleAnalytics(
            source: "test_source",
            medium: "test_medium",
            term: "test_term",
            content: "test_content",
            campaign: "test_campaign"
        )
        let expectation: [String : Any] = [
            "enable": true,
            "utm_source": "test_source",
            "utm_medium": "test_medium",
            "utm_term": "test_term",
            "utm_content": "test_content",
            "utm_campaign": "test_campaign"
        ]
        XCTAssertEncodedObject(onSettingMax, equals: expectation)
        
        let offSetting = GoogleAnalytics()
        XCTAssertEncodedObject(offSetting, equals: ["enable": false])
    }
    
}
