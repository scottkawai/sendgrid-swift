//
//  GlobalUnsubscribeDeleteTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/19/17.
//

import XCTest
@testable import SendGrid

class GlobalUnsubscribeDeleteTests: XCTestCase {
    
    func testInitializer() {
        func assert(request: GlobalUnsubscribe.Delete) {
            XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/asm/suppressions/global/foo@example.none")
            XCTAssertEqual(request.method, .DELETE)
            XCTAssertEqual(request.contentType, ContentType.json)
        }
        
        let email = GlobalUnsubscribe.Delete(email: "foo@example.none")
        assert(request: email)
        
        let event = GlobalUnsubscribe(email: "foo@example.none", created: Date())
        let request = GlobalUnsubscribe.Delete(event: event)
        assert(request: request)
    }
    
}
