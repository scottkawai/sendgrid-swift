import SendGrid
import XCTest

class BlockTests: XCTestCase {
    func testInitialization() {
        let now = Date()
        let event = Block(email: "foo@bar.com", created: now, reason: "Because", status: "4.8.15")
        XCTAssertEqual(event.email, "foo@bar.com")
        XCTAssertEqual(event.created, now)
        XCTAssertEqual(event.reason, "Because")
        XCTAssertEqual(event.status, "4.8.15")
    }
}
