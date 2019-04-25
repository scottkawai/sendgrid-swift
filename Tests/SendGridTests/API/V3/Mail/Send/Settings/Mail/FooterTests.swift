@testable import SendGrid
import XCTest

class FooterTests: XCTestCase, EncodingTester {
    typealias EncodableObject = Footer
    
    func testEncoding() {
        let onSetting = Footer(text: "Hello World", html: "<p>Hello World</p>")
        let onExpectations: [String: Any] = [
            "enable": true,
            "text": "Hello World",
            "html": "<p>Hello World</p>"
        ]
        XCTAssertEncodedObject(onSetting, equals: onExpectations)
        
        let offSetting = Footer()
        XCTAssertEncodedObject(offSetting, equals: ["enable": false])
    }
}
