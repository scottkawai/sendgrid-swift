//
//  GoogleAnalyticsTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest
@testable import SendGrid

class GoogleAnalyticsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitialization() {
        let ga = GoogleAnalytics(enable: true, source: "source", medium: "medium", term: "term", content: "content", campaign: "campaign")
        XCTAssertTrue(ga.enable)
        XCTAssertEqual(ga.source, "source")
        XCTAssertEqual(ga.medium, "medium")
        XCTAssertEqual(ga.term, "term")
        XCTAssertEqual(ga.content, "content")
        XCTAssertEqual(ga.campaign, "campaign")
    }
    
    func testJSONValue() {
        let ga = GoogleAnalytics(enable: false, source: "source", medium: "medium", term: "term", content: "content", campaign: "campaign")
        XCTAssertEqual(ga.jsonValue, "{\"ganalytics\":{\"utm_source\":\"source\",\"utm_campaign\":\"campaign\",\"enable\":false,\"utm_term\":\"term\",\"utm_medium\":\"medium\",\"utm_content\":\"content\"}}")
    }

}
