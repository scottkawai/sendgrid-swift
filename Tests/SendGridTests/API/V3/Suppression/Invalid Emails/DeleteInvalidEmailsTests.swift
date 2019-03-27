@testable import SendGrid
import XCTest

class DeleteInvalidEmailsTests: XCTestCase {
    func testInitializer() {
        let request = DeleteInvalidEmails(emails: "foo@example.none", "bar@example.none")
        XCTAssertEqual(request.description, """
        # DELETE /v3/suppression/invalid_emails

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

            + Body

                    {"emails":["foo@example.none","bar@example.none"]}

        """)
    }

    func testDeleteAll() {
        let request = DeleteInvalidEmails.all
        XCTAssertEqual(request.description, """
        # DELETE /v3/suppression/invalid_emails

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

            + Body

                    {"delete_all":true}

        """)
    }
}
