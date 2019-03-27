@testable import SendGrid
import XCTest

class DeleteBouncesTests: XCTestCase {
    func testInitializer() {
        func assert(request: DeleteBounces) {
            XCTAssertEqual(request.description, """
            # DELETE /v3/suppression/bounces

            + Request (application/json)

                + Headers

                        Accept: application/json
                        Content-Type: application/json

                + Body

                        {"emails":["foo@example.none","bar@example.none"]}

            """)
        }

        let emails = DeleteBounces(emails: "foo@example.none", "bar@example.none")
        assert(request: emails)

        let fooBounce = Bounce(email: "foo@example.none", created: Date(), reason: "Because", status: "4.8.15")
        let barBounce = Bounce(email: "bar@example.none", created: Date(), reason: "Because", status: "16.23.42")
        let events = DeleteBounces(events: fooBounce, barBounce)
        assert(request: events)
    }

    func testDeleteAll() {
        let request = DeleteBounces.all
        XCTAssertEqual(request.description, """
        # DELETE /v3/suppression/bounces

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

            + Body

                    {"delete_all":true}

        """)
    }
}
