//
//  ContentTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/13/17.
//

import XCTest
@testable import SendGrid

class ContentTests: XCTestCase, EncodingTester {
    typealias EncodableObject = Content
    
    func testEncoding() {
        let plain = Content.plainText(body: "Hello World")
        XCTAssert(encodableObject: plain, equals: ["type": "text/plain", "value": "Hello World"])
    }
    
}
