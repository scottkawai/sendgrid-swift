//
//  GlobalUnsubcribeAddTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/20/17.
//

import XCTest
@testable import SendGrid

class GlobalUnsubcribeAddTests: XCTestCase {
    
    func testInitialization() {
        func assert(request: GlobalUnsubscribe.Add) {
            XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/asm/suppressions/global")
            XCTAssertEqual(request.method, .POST)
            XCTAssertEqual(request.contentType, ContentType.json)
            XCTAssertEqual(request.encodedString(), "{\"recipient_emails\":[\"foo@example.none\",\"bar@example.none\"]}")
        }
        
        let emails = GlobalUnsubscribe.Add(emails: "foo@example.none", "bar@example.none")
        assert(request: emails)
        
        let addresses = GlobalUnsubscribe.Add(addresses: Address(email: "foo@example.none"), Address(email: "bar@example.none"))
        assert(request: addresses)
    }
    
}
