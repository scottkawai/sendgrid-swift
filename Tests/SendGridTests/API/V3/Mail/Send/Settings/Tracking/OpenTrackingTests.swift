@testable import SendGrid
import XCTest

class OpenTrackingTests: XCTestCase, EncodingTester {
    typealias EncodableObject = OpenTracking
    
    func testEncoding() {
        let onSettingMin = OpenTracking(location: .bottom)
        XCTAssertEncodedObject(onSettingMin, equals: ["enable": true])
        
        let onSettingMax = OpenTracking(location: .at(tag: "%open%"))
        XCTAssertEncodedObject(onSettingMax, equals: ["enable": true, "substitution_tag": "%open%"])
        
        let offSetting = OpenTracking(location: .off)
        XCTAssertEncodedObject(offSetting, equals: ["enable": false])
    }
}
