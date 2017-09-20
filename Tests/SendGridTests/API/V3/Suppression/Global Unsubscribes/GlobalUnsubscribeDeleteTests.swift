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
        let request = GlobalUnsubscribe.Delete(email: "foo@example.none")
        XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/asm/suppressions/global/foo@example.none")
        XCTAssertEqual(request.method, .DELETE)
        XCTAssertEqual(request.contentType, ContentType.json)
    }
    
}
