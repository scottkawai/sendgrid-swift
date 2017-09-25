//
//  BounceDeleteTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/19/17.
//

import XCTest
@testable import SendGrid

class BounceDeleteTests: XCTestCase {
    
    func testInitializer() {
        func assert(request: Bounce.Delete) {
            XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/suppression/bounces")
            XCTAssertEqual(request.method, .DELETE)
            XCTAssertEqual(request.contentType, ContentType.json)
            XCTAssertEqual(request.encodedString(), "{\"emails\":[\"foo@example.none\",\"bar@example.none\"]}")
        }
        let emails = Bounce.Delete(emails: "foo@example.none", "bar@example.none")
        assert(request: emails)
        
        let fooBounce = Bounce(email: "foo@example.none", created: Date(), reason: "Because", status: "4.8.15")
        let barBounce = Bounce(email: "bar@example.none", created: Date(), reason: "Because", status: "16.23.42")
        let events = Bounce.Delete(events: fooBounce, barBounce)
        assert(request: events)
    }
    
    func testDeleteAll() {
        let request = Bounce.Delete.all
        XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/suppression/bounces")
        XCTAssertEqual(request.method, .DELETE)
        XCTAssertEqual(request.contentType, ContentType.json)
        XCTAssertEqual(request.encodedString(), "{\"delete_all\":true}")
    }
    
}
