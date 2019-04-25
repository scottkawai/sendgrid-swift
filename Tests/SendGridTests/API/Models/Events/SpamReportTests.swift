import SendGrid
import XCTest

class SpamReportTests: XCTestCase {
    func testInitialization() {
        let now = Date()
        let event = SpamReport(email: "foo@bar.com", created: now, ip: "123.45.67.89")
        XCTAssertEqual(event.email, "foo@bar.com")
        XCTAssertEqual(event.created, now)
        XCTAssertEqual(event.ip, "123.45.67.89")
    }
}
