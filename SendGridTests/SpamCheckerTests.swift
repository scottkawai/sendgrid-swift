//
//  SpamCheckerTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/17/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest
@testable import SendGrid

class SpamCheckerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        let basic = SpamChecker(enable: true, threshold: 4)
        XCTAssertTrue(basic.enable)
        XCTAssertEqual(basic.threshold, 4)
        XCTAssertNil(basic.postURL)
        
        let url = URL(string: "http://localhost")
        let advance = SpamChecker(enable: false, threshold: 10, url: url)
        XCTAssertFalse(advance.enable)
        XCTAssertEqual(advance.threshold, 10)
        XCTAssertEqual(advance.postURL?.absoluteString, "http://localhost")
    }
    
    func testJSONValue() {
        let basic = SpamChecker(enable: true, threshold: 1)
        XCTAssertEqual(basic.jsonValue, "{\"spam_check\":{\"threshold\":1,\"enable\":true}}")
        
        let url = URL(string: "http://localhost")
        let advance = SpamChecker(enable: false, threshold: 8, url: url)
        XCTAssertEqual(advance.jsonValue, "{\"spam_check\":{\"threshold\":8,\"post_to_url\":\"http:\\/\\/localhost\",\"enable\":false}}")
    }
    
    func testValidation() {
        do {
            let over = SpamChecker(enable: false, threshold: 42)
            try over.validate()
            XCTFail("Expected an error to be thrown with a threshold over 10, but no errors were raised.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.thresholdOutOfRange(42).description)
        }
        
        do {
            let under = SpamChecker(enable: false, threshold: 0)
            try under.validate()
            XCTFail("Expected an error to be thrown with a threshold under 1, but no errors were raised.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.thresholdOutOfRange(0).description)
        }
    }
}
