@testable import SendGrid
import XCTest

class SessionTests: XCTestCase {
    func testSendWithoutAuth() {
        let session = Session()
        let personalization = [Personalization(recipients: "test@example.com")]
        let email = Email(personalizations: personalization, from: Address(email: "foo@bar.com"), content: [Content.plainText(body: "plain")], subject: "Hello World")
        do {
            try session.send(request: email)
            XCTFail("Expected failure when sending a request without authentication, but nothing was thrown.")
        } catch SendGrid.Exception.Session.authenticationMissing {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }

    func testSendImpersonation() {
        let session = Session()
        session.authentication = .apiKey("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        session.onBehalfOf = "foo"
        Constants.ApiHost = "http://localhost"
        let goodRequest = RetrieveGlobalStatistics(startDate: Date())
        do {
            try session.send(request: goodRequest)
        } catch SendGrid.Exception.Session.impersonationNotAllowed {
            XCTFail("Impersonation was disallowed on a request that should allow it.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        let personalization = [Personalization(recipients: "test@example.com")]
        let email = Email(personalizations: personalization, from: Address(email: "foo@bar.com"), content: [Content.plainText(body: "plain")], subject: "Hello World")
        do {
            try session.send(request: email)
            XCTFail("Unexpected success in impersonating an email send.")
        } catch {
            XCTAssertEqual("\(error)", SendGrid.Exception.Session.impersonationNotAllowed.description)
        }
    }
}
