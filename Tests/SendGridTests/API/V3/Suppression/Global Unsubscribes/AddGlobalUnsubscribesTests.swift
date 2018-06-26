//
//  AddGlobalUnsubscribesTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/20/17.
//

import XCTest
@testable import SendGrid

class AddGlobalUnsubscribesTests: XCTestCase {
    
    func testInitialization() {
        func assert(request: AddGlobalUnsubscribes) {
            XCTAssertEqual(request.description, """
            # POST /v3/asm/suppressions/global
            
            + Request (application/json)

                + Headers
            
                        Accept: application/json
                        Content-Type: application/json
            
                + Body
            
                        {"recipient_emails":["foo@example.none","bar@example.none"]}

            """)
        }
        
        let emails = AddGlobalUnsubscribes(emails: "foo@example.none", "bar@example.none")
        assert(request: emails)
        
        let addresses = AddGlobalUnsubscribes(addresses: Address(email: "foo@example.none"), Address(email: "bar@example.none"))
        assert(request: addresses)
    }
    
}
