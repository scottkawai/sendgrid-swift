//
//  SpamReportDeleteTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/19/17.
//

import XCTest
@testable import SendGrid

class SpamReportDeleteTests: XCTestCase {
    
    func testInitializer() {
        let request = SpamReport.Delete(emails: "foo@example.none", "bar@example.none")
        XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/suppression/spam_reports")
        XCTAssertEqual(request.method, .DELETE)
        XCTAssertEqual(request.contentType, ContentType.json)
        XCTAssertEqual(request.encodedString(), "{\"emails\":[\"foo@example.none\",\"bar@example.none\"]}")
    }
    
    func testDeleteAll() {
        let request = SpamReport.Delete.all
        XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/suppression/spam_reports")
        XCTAssertEqual(request.method, .DELETE)
        XCTAssertEqual(request.contentType, ContentType.json)
        XCTAssertEqual(request.encodedString(), "{\"delete_all\":true}")
    }
    
}
