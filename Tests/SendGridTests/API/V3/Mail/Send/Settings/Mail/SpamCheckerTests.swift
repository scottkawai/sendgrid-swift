//
//  SpamCheckerTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/16/17.
//

import XCTest
@testable import SendGrid

class SpamCheckerTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = SpamChecker
    
    func testEncoding() {
        let onSettingMin = SpamChecker(threshold: 4)
        XCTAssertEncodedObject(onSettingMin, equals: ["enable": true, "threshold": 4])
        
        let onSettingMax = SpamChecker(threshold: 8, url: URL(string: "http://example.none"))
        let onSettingMaxExpectations: [String : Any] = [
            "enable": true,
            "threshold": 8,
            "post_to_url": "http://example.none"
        ]
        XCTAssertEncodedObject(onSettingMax, equals: onSettingMaxExpectations)
        
        let offSetting = SpamChecker()
        XCTAssertEncodedObject(offSetting, equals: ["enable": false])
    }
    
}
