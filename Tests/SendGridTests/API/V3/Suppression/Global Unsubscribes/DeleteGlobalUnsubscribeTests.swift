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
            XCTAssertEqual(request.description, """
            # DELETE /v3/asm/suppressions/global/foo@example.none

            + Request (application/json)

                + Headers

                        Accept: application/json
                        Content-Type: application/json

            """)
        }
        
        let email = DeleteGlobalUnsubscribe(email: "foo@example.none")
        assert(request: email)
        
        let event = GlobalUnsubscribe(email: "foo@example.none", created: Date())
        let request = DeleteGlobalUnsubscribe(event: event)
        assert(request: request)
    }
    
}
