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
        XCTAssertEncodedObject(plain, equals: ["type": "text/plain", "value": "Hello World"])
    }
    
    func testInitialization() {
        let c = Content(contentType: .plainText, value: "Hello World")
        XCTAssertEqual(c.type.description, "text/plain")
        XCTAssertEqual(c.value, "Hello World")
    }
    
    func testClassInitializers() {
        let plain = Content.plainText(body: "plain")
        XCTAssertEqual(plain.type.description, ContentType.plainText.description)
        XCTAssertEqual(plain.value, "plain")
        
        let html = Content.html(body: "html")
        XCTAssertEqual(html.type.description, ContentType.htmlText.description)
        XCTAssertEqual(html.value, "html")
        
        let both = Content.emailBody(plain: "plain", html: "html")
        XCTAssertEqual(both.count, 2)
        XCTAssertEqual(both[0].value, "plain")
        XCTAssertEqual(both[0].type.description, ContentType.plainText.description)
        XCTAssertEqual(both[1].value, "html")
        XCTAssertEqual(both[1].type.description, ContentType.htmlText.description)
    }
    
    func testValidation() {
        do {
            let html = Content(contentType: .jpeg, value: "test")
            try html.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let semicolon = Content(contentType: ContentType(type: "application;", subtype: "json"), value: "{}")
            try semicolon.validate()
            XCTFail("Expected error to be thrown when a content type has a semicolon, but nothing was thrown.")
        } catch SendGrid.Exception.ContentType.invalidContentType(let errorType) {
            XCTAssertEqual(errorType, "application;/json")
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let nl = Content(contentType: ContentType(type: "application\n\r", subtype: "json"), value: "{}")
            try nl.validate()
            XCTFail("Expected error to be thrown when a content type has a newline, but nothing was thrown.")
        } catch SendGrid.Exception.ContentType.invalidContentType(let errorType) {
            XCTAssertEqual(errorType, "application\n\r/json")
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let nl = Content(contentType: ContentType(type: "", subtype: ""), value: "{}")
            try nl.validate()
            XCTFail("Expected error to be thrown when a content type is an empty string, but nothing was thrown.")
        } catch SendGrid.Exception.ContentType.invalidContentType(let errorType) {
            XCTAssertEqual(errorType, "/")
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let empty = Content(contentType: .plainText, value: "")
            try empty.validate()
            XCTFail("Expected an empty content value to throw an error, but no error was thrown.")
        } catch SendGrid.Exception.Mail.contentHasEmptyString {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}
