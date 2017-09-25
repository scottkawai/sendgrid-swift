//
//  ContentTypeTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/8/17.
//

import XCTest
@testable import SendGrid

class ContentTypeTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = TestObject
    struct TestObject: Encodable {
        let type: ContentType
    }
    
    func testEncoding() {
        let test = TestObject(type: .json)
        XCTAssertEncodedObject(test, equals: ["type": "application/json"])
    }
    
    func testInitializerAndDescription() {
        let type = ContentType(type: "foo", subtype: "bar")
        XCTAssertEqual(type.type, "foo")
        XCTAssertEqual(type.subtype, "bar")
        XCTAssertEqual(type.description, "foo/bar")
    }
    
    func testRawInitializer() {
        let good = ContentType(rawValue: "foo/bar")
        XCTAssertNotNil(good)
        XCTAssertEqual(good?.type, "foo")
        XCTAssertEqual(good?.subtype, "bar")
        XCTAssertEqual(good?.description, "foo/bar")
        
        let badCases = [
            "foo/bar/baz": "if there is more than 1 slash",
            "foobar": "if there is no slash"
        ]
        for (type, description) in badCases {
            XCTAssertNil(ContentType(rawValue: type), "Returns `nil` \(description)")
        }
    }
    
    func testIndex() {
        let plain = ContentType(type: "text", subtype: "plain")
        let html = ContentType(type: "text", subtype: "html")
        let other = ContentType(type: "foo", subtype: "bar")
        XCTAssertEqual(plain.index, 0)
        XCTAssertEqual(html.index, 1)
        XCTAssertEqual(other.index, 2)
    }
    
}
