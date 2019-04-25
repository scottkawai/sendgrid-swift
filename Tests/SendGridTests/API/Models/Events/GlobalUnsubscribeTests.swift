import SendGrid
import XCTest

class GlobalUnsubscribeTests: XCTestCase {
    func testInitialization() {
        let now = Date()
        let event = GlobalUnsubscribe(email: "foo@bar.com", created: now)
        XCTAssertEqual(event.email, "foo@bar.com")
        XCTAssertEqual(event.created, now)
    }
}
