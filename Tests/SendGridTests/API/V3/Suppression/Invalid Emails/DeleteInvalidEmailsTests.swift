//
//  DeleteInvalidEmailsTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/19/17.
//

import XCTest
@testable import SendGrid

class DeleteInvalidEmailsTests: XCTestCase {
    
    func testInitializer() {
        let request = DeleteInvalidEmails(emails: "foo@example.none", "bar@example.none")
        XCTAssertEqual(request.description, "{\"emails\":[\"foo@example.none\",\"bar@example.none\"]}")
    }
    
    func testDeleteAll() {
        let request = DeleteInvalidEmails.all
        XCTAssertEqual(request.description, "{\"delete_all\":true}")
    }
    
}
