//
//  FooterTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/16/17.
//

import XCTest
@testable import SendGrid

class FooterTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = Footer
    
    func testEncoding() {
        let onSetting = Footer(text: "Hello World", html: "<p>Hello World</p>")
        let onExpectations: [String : Any] = [
            "enable": true,
            "text": "Hello World",
            "html": "<p>Hello World</p>"
        ]
        XCTAssertEncodedObject(onSetting, equals: onExpectations)
        
        let offSetting = Footer()
        XCTAssertEncodedObject(offSetting, equals: ["enable": false])
    }
    
}
