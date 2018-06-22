//
//  DeleteGlobalUnsubscribeTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/19/17.
//

import XCTest
@testable import SendGrid

class DeleteGlobalUnsubscribeTests: XCTestCase {
    
    func testInitializer() {
        func assert(request: DeleteGlobalUnsubscribe) {
            XCTAssertEqual(request.description, "https://api.sendgrid.com/v3/asm/suppressions/global/foo@example.none")
        }
        
        let email = DeleteGlobalUnsubscribe(email: "foo@example.none")
        assert(request: email)
        
        let event = GlobalUnsubscribe(email: "foo@example.none", created: Date())
        let request = DeleteGlobalUnsubscribe(event: event)
        assert(request: request)
    }
    
}
