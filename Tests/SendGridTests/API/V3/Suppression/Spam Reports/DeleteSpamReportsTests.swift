@testable import SendGrid
import XCTest

class DeleteSpamReportsTests: XCTestCase {
    func testInitializer() {
        let request = DeleteSpamReports(emails: "foo@example.none", "bar@example.none")
        XCTAssertEqual(request.description, """
        # DELETE /v3/suppression/spam_reports

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

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

                    Accept: application/json
                    Content-Type: application/json

            + Body

                    {"delete_all":true}

        """)
    }
}
