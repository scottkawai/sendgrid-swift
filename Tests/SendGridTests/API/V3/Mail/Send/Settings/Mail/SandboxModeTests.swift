@testable import SendGrid
import XCTest

class SandboxModeTests: XCTestCase, EncodingTester {
    typealias EncodableObject = SandboxMode
    
    func testEncoding() {
        let on = SandboxMode(enable: true)
        XCTAssertEncodedObject(on, equals: ["enable": true])
        
        let off = SandboxMode(enable: false)
        XCTAssertEncodedObject(off, equals: ["enable": false])
        
        let unspecified = SandboxMode()
        XCTAssertEncodedObject(unspecified, equals: ["enable": true])
    }
}
