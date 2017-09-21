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
    
    func testInitialization() {
        let basic = SpamChecker(threshold: 4)
        XCTAssertTrue(basic.enable)
        XCTAssertEqual(basic.threshold, 4)
        XCTAssertNil(basic.postURL)
        
        let url = URL(string: "http://localhost")
        let advance = SpamChecker(threshold: 10, url: url)
        XCTAssertTrue(advance.enable)
        XCTAssertEqual(advance.threshold, 10)
        XCTAssertEqual(advance.postURL?.absoluteString, "http://localhost")
        
        let off = SpamChecker()
        XCTAssertFalse(off.enable)
        XCTAssertNil(off.threshold)
        XCTAssertNil(off.postURL)
    }
    
    func testValidation() {
        let good = SpamChecker(threshold: 5)
        XCTAssertNoThrow(try good.validate())
        
        do {
            let over = SpamChecker(threshold: 42)
            try over.validate()
            XCTFail("Expected an error to be thrown with a threshold over 10, but no errors were raised.")
        } catch SendGrid.Exception.Mail.thresholdOutOfRange(let i) {
            XCTAssertEqual(i, 42)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let under = SpamChecker(threshold: 0)
            try under.validate()
            XCTFail("Expected an error to be thrown with a threshold under 1, but no errors were raised.")
        } catch SendGrid.Exception.Mail.thresholdOutOfRange(let i) {
            XCTAssertEqual(i, 0)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}
