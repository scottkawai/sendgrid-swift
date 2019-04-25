@testable import SendGrid
import XCTest

class DeleteBlocksTests: XCTestCase {
    func testInitializer() {
        let request = DeleteBlocks(emails: "foo@example.none", "bar@example.none")
        XCTAssertEqual(request.description, """
        # DELETE /v3/suppression/blocks

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

            + Body

                    {"emails":["foo@example.none","bar@example.none"]}

        """)
    }

    func testDeleteAll() {
        let request = DeleteBlocks.all
        XCTAssertEqual(request.description, """
        # DELETE /v3/suppression/blocks

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

            + Body

                    {"delete_all":true}

        """)
    }
}
