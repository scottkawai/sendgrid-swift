@testable import SendGrid
import XCTest

class ValidateEmailTests: XCTestCase {
    func testMinimalInitialization() {
        let requestEmail = ValidateEmail(email: "foo@example.none")
        XCTAssertEqual(requestEmail.description, """
        # POST /v3/validations/email

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

            + Body

                    {"email":"foo@example.none"}

        """)

        let address = Address(email: "foo@example.none", name: "Foo Bar")
        let requestAddress = ValidateEmail(address: address)
        XCTAssertEqual(requestAddress.description, """
        # POST /v3/validations/email

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

            + Body

                    {"email":"foo@example.none"}

        """)
    }

    func testMaxInitialization() {
        let requestEmail = ValidateEmail(email: "foo@example.none", source: "Sign Up Form")
        XCTAssertEqual(requestEmail.description, """
        # POST /v3/validations/email

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

            + Body

                    {"email":"foo@example.none","source":"SIGN UP FORM"}

        """)

        let address = Address(email: "foo@example.none", name: "Foo Bar")
        let requestAddress = ValidateEmail(address: address, source: .supportForm)
        XCTAssertEqual(requestAddress.description, """
        # POST /v3/validations/email

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

            + Body

                    {"email":"foo@example.none","source":"SUPPORT FORM"}

        """)
    }
}

private extension ValidateEmail.Source {
    static let supportForm = ValidateEmail.Source("Support Form")
}
