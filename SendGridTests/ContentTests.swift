//
//  ContentTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest

class ContentTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitialization() {
        let c = Content(contentType: .PlainText, value: "Hello World")
        XCTAssertEqual(c.type.description, "text/plain")
        XCTAssertEqual(c.value, "Hello World")
    }
    
    func testDictionaryValue() {
        let c = Content(contentType: .HTMLText, value: "<h1>Hello World</h1>")
        XCTAssertEqual(c.dictionaryValue["type"] as? String, "text/html")
        XCTAssertEqual(c.dictionaryValue["value"] as? String, "<h1>Hello World</h1>")
    }
    
    func testJSONValue() {
        let c = Content(contentType: .Other("application/json"), value: "{}")
        XCTAssertEqual(c.jsonValue, "{\"value\":\"{}\",\"type\":\"application\\/json\"}")
    }
    
    func testClassInitializers() {
        let plain = Content.plainTextContent("plain")
        XCTAssertEqual(plain.type.description, ContentType.PlainText.description)
        XCTAssertEqual(plain.value, "plain")
        
        let html = Content.htmlContent("html")
        XCTAssertEqual(html.type.description, ContentType.HTMLText.description)
        XCTAssertEqual(html.value, "html")
        
        let both = Content.emailContent(plain: "plain", html: "html")
        XCTAssertEqual(both.count, 2)
        XCTAssertEqual(both[0].value, "plain")
        XCTAssertEqual(both[0].type.description, ContentType.PlainText.description)
        XCTAssertEqual(both[1].value, "html")
        XCTAssertEqual(both[1].type.description, ContentType.HTMLText.description)
    }
    
    func testValidation() {
        do {
            let html = Content(contentType: .JPEG, value: "test")
            try html.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        do {
            let semicolon = Content(contentType: .Other("application;json"), value: "{}")
            try semicolon.validate()
            XCTFail("Expected error to be thrown when a content type has a semicolon, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", Error.Mail.InvalidContentType("application;json").description)
        }
        
        do {
            let nl = Content(contentType: .Other("application\n\rjson"), value: "{}")
            try nl.validate()
            XCTFail("Expected error to be thrown when a content type has a newline, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", Error.Mail.InvalidContentType("application\n\rjson").description)
        }
        
        do {
            let nl = Content(contentType: .Other(""), value: "{}")
            try nl.validate()
            XCTFail("Expected error to be thrown when a content type is an empty string, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", Error.Mail.InvalidContentType("").description)
        }
        
        do {
            let empty = Content(contentType: .PlainText, value: "")
            try empty.validate()
            XCTFail("Expected an empty content value to throw an error, but no error was thrown.")
        } catch {
            XCTAssertEqual("\(error)", Error.Mail.ContentHasEmptyString.description)
        }
    }

}
