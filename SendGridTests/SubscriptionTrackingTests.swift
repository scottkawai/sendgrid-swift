//
//  SubscriptionTrackingTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest

class SubscriptionTrackingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        let basicOn = SubscriptionTracking(enable: true)
        XCTAssertTrue(basicOn.enable)
        XCTAssertEqual(basicOn.text, "If you would like to unsubscribe and stop receiving these emails click here: <% %>.")
        XCTAssertEqual(basicOn.html, "<p>If you would like to unsubscribe and stop receiving these emails <% click here %>.</p>")
        XCTAssertNil(basicOn.substitutionTag)
        
        let complex = SubscriptionTracking(enable: false, plainText: Constants.SubscriptionTracking.DefaultPlainText, HTML: Constants.SubscriptionTracking.DefaultHTMLText, substitutionTag: "%unsub%")
        XCTAssertFalse(complex.enable)
        XCTAssertEqual(complex.substitutionTag, "%unsub%")
        
        let custom = SubscriptionTracking(enable: true, plainText: "Unsubscribe: <% %>", HTML: "<% Unsubscribe %>", substitutionTag: nil)
        XCTAssertTrue(custom.enable)
        XCTAssertEqual(custom.text, "Unsubscribe: <% %>")
        XCTAssertEqual(custom.html, "<% Unsubscribe %>")
        
        do {
            let bad = SubscriptionTracking(enable: false, plainText: "Unsubscribe", HTML: "<% Unsubscribe %>")
            try bad.validate()
            XCTFail("Expected error when using plain text without <% %> tag, but received no error.")
        } catch {
            XCTAssertEqual("\(error)", Error.Mail.MissingSubscriptionTrackingTag.description)
        }
        
        do {
            let bad = SubscriptionTracking(enable: false, plainText: "Unsubscribe: <% %>", HTML: "<p>Unsubscribe</p>")
            try bad.validate()
            XCTFail("Expected error when using HTML text without <% %> tag, but received no error.")
        } catch {
            XCTAssertEqual("\(error)", Error.Mail.MissingSubscriptionTrackingTag.description)
        }
    }
    
    func testJSONValue() {
        let basic = SubscriptionTracking(enable: true)
        XCTAssertEqual(basic.jsonValue, "{\"subscription_tracking\":{\"html\":\"<p>If you would like to unsubscribe and stop receiving these emails <% click here %>.<\\/p>\",\"text\":\"If you would like to unsubscribe and stop receiving these emails click here: <% %>.\",\"enable\":true}}")
        
        let complex = SubscriptionTracking(enable: false, plainText: Constants.SubscriptionTracking.DefaultPlainText, HTML: Constants.SubscriptionTracking.DefaultHTMLText, substitutionTag: "%unsub%")
        XCTAssertEqual(complex.jsonValue, "{\"subscription_tracking\":{\"enable\":false,\"substitution_tag\":\"%unsub%\",\"text\":\"If you would like to unsubscribe and stop receiving these emails click here: <% %>.\",\"html\":\"<p>If you would like to unsubscribe and stop receiving these emails <% click here %>.<\\/p>\"}}")
        
        let custom = SubscriptionTracking(enable: true, plainText: "Unsubscribe: <% %>", HTML: "<% Unsubscribe %>", substitutionTag: nil)
        XCTAssertEqual(custom.jsonValue, "{\"subscription_tracking\":{\"html\":\"<% Unsubscribe %>\",\"text\":\"Unsubscribe: <% %>\",\"enable\":true}}")
    }
    
}
