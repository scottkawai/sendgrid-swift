//
//  DeleteSpamReportsTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/19/17.
//

import XCTest
@testable import SendGrid

class DeleteSpamReportsTests: XCTestCase {
    
    func testInitializer() {
        let request = DeleteSpamReports(emails: "foo@example.none", "bar@example.none")
        XCTAssertEqual(request.description, """
        # DELETE /v3/suppression/spam_reports

        + Request (application/json)

            + Headers

                    Content-Type: application/json
                    Accept: application/json

            + Body

                    {"emails":["foo@example.none","bar@example.none"]}

        """)
    }
    
    func testDeleteAll() {
        let request = DeleteSpamReports.all
        XCTAssertEqual(request.description, """
        # DELETE /v3/suppression/spam_reports

        + Request (application/json)

            + Headers

                    Content-Type: application/json
                    Accept: application/json

            + Body

                    {"delete_all":true}

        """)
    }
    
}
