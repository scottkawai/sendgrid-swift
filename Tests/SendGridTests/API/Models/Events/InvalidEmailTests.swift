import SendGrid
import XCTest

class InvalidEmailTests: XCTestCase {
    func testInitialization() {
        let now = Date()
        let event = InvalidEmail(email: "foo@bar", created: now, reason: "Missing TLD")
        XCTAssertEqual(event.email, "foo@bar")
        XCTAssertEqual(event.created, now)
        XCTAssertEqual(event.reason, "Missing TLD")
    }
}
