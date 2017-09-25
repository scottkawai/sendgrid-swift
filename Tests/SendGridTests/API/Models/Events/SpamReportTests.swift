//
//  SpamReportTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/21/17.
//

import XCTest
import SendGrid

class SpamReportTests: XCTestCase {
    
    func testInitialization() {
        let now = Date()
        let event = SpamReport(email: "foo@bar.com", created: now, ip: "123.45.67.89")
        XCTAssertEqual(event.email, "foo@bar.com")
        XCTAssertEqual(event.created, now)
        XCTAssertEqual(event.ip, "123.45.67.89")
    }
    
}
