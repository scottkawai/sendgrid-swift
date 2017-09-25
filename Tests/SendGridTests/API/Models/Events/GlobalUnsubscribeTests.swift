//
//  GlobalUnsubscribeTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/21/17.
//

import XCTest
import SendGrid

class GlobalUnsubscribeTests: XCTestCase {
    
    func testInitialization() {
        let now = Date()
        let event = GlobalUnsubscribe(email: "foo@bar.com", created: now)
        XCTAssertEqual(event.email, "foo@bar.com")
        XCTAssertEqual(event.created, now)
    }
    
}
