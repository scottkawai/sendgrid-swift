//
//  InvalidEmailDeleteTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/19/17.
//

import XCTest
@testable import SendGrid

class InvalidEmailDeleteTests: XCTestCase {
    
    func testInitializer() {
        let request = InvalidEmail.Delete(emails: "foo@example.none", "bar@example.none")
        XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/suppression/invalid_emails")
        XCTAssertEqual(request.method, .DELETE)
        XCTAssertEqual(request.contentType, ContentType.json)
        XCTAssertEqual(request.encodedString(), "{\"emails\":[\"foo@example.none\",\"bar@example.none\"]}")
    }
    
    func testDeleteAll() {
        let request = InvalidEmail.Delete.all
        XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/suppression/invalid_emails")
        XCTAssertEqual(request.method, .DELETE)
        XCTAssertEqual(request.contentType, ContentType.json)
        XCTAssertEqual(request.encodedString(), "{\"delete_all\":true}")
    }
    
}
