@testable import SendGrid
import XCTest

class ClickTrackingTests: XCTestCase, EncodingTester {
    typealias EncodableObject = ClickTracking
    
    func testExample() {
        let onSettingMin = ClickTracking(section: .htmlBody)
        XCTAssertEncodedObject(onSettingMin, equals: ["enable": true, "enable_text": false])
        
        let onSettingMax = ClickTracking(section: .plainTextAndHTMLBodies)
        XCTAssertEncodedObject(onSettingMax, equals: ["enable": true, "enable_text": true])
        
        let offSetting = ClickTracking(section: .off)
        XCTAssertEncodedObject(offSetting, equals: ["enable": false])
    }
}
