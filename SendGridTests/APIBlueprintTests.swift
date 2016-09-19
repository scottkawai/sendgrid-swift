//
//  APIBlueprintTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/10/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest
@testable import SendGrid

class APIBlueprintTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasicInit() {
        let print = APIBlueprint(method: .POST, location: "/v3/test", contentType: ContentType.json, type: APIBlueprint.MessageType.Request, headers: ["X-Foo":"Bar"], parameters: ["foo":"bar"], statusCode: 200)
        XCTAssertEqual(print.method.description, "POST")
        XCTAssertEqual(print.location, "/v3/test")
        XCTAssertEqual(print.contentType.description, "application/json")
        XCTAssertEqual(print.type.rawValue, "Request")
        XCTAssertEqual(print.headers!["X-Foo"], "Bar")
        XCTAssertEqual(print.statusCode, 200)
        XCTAssertEqual(print.body, "{\n  \"foo\" : \"bar\"\n}")
        
        let put = APIBlueprint(method: .PUT, location: "/v3/test", contentType: ContentType.formUrlEncoded, type: APIBlueprint.MessageType.Response, headers: ["X-Foo":"Bar"], parameters: ["foo":"bar"], statusCode: nil)
        XCTAssertEqual(put.method.description, "PUT")
        XCTAssertEqual(put.location, "/v3/test")
        XCTAssertEqual(put.contentType.description, "application/x-www-form-urlencoded")
        XCTAssertEqual(put.type.rawValue, "Response")
        XCTAssertEqual(put.headers!["X-Foo"], "Bar")
        XCTAssertNil(put.statusCode)
        XCTAssertEqual(put.body, "foo=bar")
        
        let post = APIBlueprint(method: .POST, location: "/v3/test", contentType: ContentType.csv, type: APIBlueprint.MessageType.Request, headers: ["X-Foo":"Bar"], parameters: ["foo":"bar"], statusCode: nil)
        XCTAssertEqual(post.method.description, "POST")
        XCTAssertEqual(post.location, "/v3/test")
        XCTAssertEqual(post.contentType.description, "application/csv")
        XCTAssertEqual(post.type.rawValue, "Request")
        XCTAssertEqual(post.headers!["X-Foo"], "Bar")
        XCTAssertNil(post.statusCode)
        XCTAssertNil(post.body)
    }
    
    func testInitWithRequest() {
        let request = Email(
            personalizations: [Personalization(recipients: "test@example.com")],
            from: Address("foo@bar.com"),
            content: [Content(contentType: ContentType.plainText, value: "Hello World")],
            subject: "Hello World"
        )
        let blue = APIBlueprint(request: request)
        XCTAssertEqual(blue.method.description, "POST")
        XCTAssertEqual(blue.location, "/v3/mail/send")
        XCTAssertEqual(blue.contentType.description, "application/json")
        XCTAssertEqual(blue.type.rawValue, "Request")
        XCTAssertNil(blue.statusCode)
        XCTAssertEqual(blue.body, "{\n  \"from\" : {\n    \"email\" : \"foo@bar.com\"\n  },\n  \"content\" : [\n    {\n      \"type\" : \"text\\/plain\",\n      \"value\" : \"Hello World\"\n    }\n  ],\n  \"personalizations\" : [\n    {\n      \"to\" : [\n        {\n          \"email\" : \"test@example.com\"\n        }\n      ]\n    }\n  ],\n  \"subject\" : \"Hello World\"\n}")
        
        let getRequest = RequestTests.Foo()
        let getBlue = APIBlueprint(request: getRequest)
        XCTAssertEqual(getBlue.method.description, "GET")
        XCTAssertEqual(getBlue.location, "/foo/bar?q=1")
    }
    
    func testInitWithResponse() {
        let request = Email(
            personalizations: [Personalization(recipients: "test@example.com")],
            from: Address("foo@bar.com"),
            content: [Content(contentType: ContentType.plainText, value: "Hello World")],
            subject: "Hello World"
        )
        let response = Response(request: request)
        let blue = APIBlueprint(response: response)
        XCTAssertEqual(blue?.method.description, "POST")
        XCTAssertEqual(blue?.location, "/v3/mail/send")
        XCTAssertEqual(blue?.contentType.description, "text/plain")
        XCTAssertEqual(blue?.type.rawValue, "Response")
        XCTAssertNil(blue?.statusCode)
        XCTAssertNil(blue?.body)
        
        let getRequest = RequestTests.Foo()
        let responseData = ParameterEncoding.jsonData(from: ["foo":"bar"])
        let urlResponse = HTTPURLResponse(url: URL(fileURLWithPath: "/foo"), statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": ContentType.json.description])
        let getResponse = Response(request: getRequest, data: responseData, urlResponse: urlResponse)
        
        let getBlue = APIBlueprint(response: getResponse)
        XCTAssertEqual(getBlue!.method.description, "GET")
        XCTAssertEqual(getBlue!.location, "/foo/bar?q=1")
    }
    
    func testDescription() {
        let put = APIBlueprint(method: .PUT, location: "/v3/test", contentType: ContentType.formUrlEncoded, type: APIBlueprint.MessageType.Response, headers: ["X-Foo":"Bar"], parameters: ["foo":"bar"], statusCode: 200)
        XCTAssertEqual(put.description, "# PUT /v3/test\n\n+ Response 200 (application/x-www-form-urlencoded)\n\n    + Headers\n\n            X-Foo: Bar\n\n    + Body\n\n            foo=bar")
        
        let post = APIBlueprint(method: .POST, location: "/v3/test", contentType: ContentType.json, type: APIBlueprint.MessageType.Request, headers: nil, parameters: ["foo":"bar"], statusCode: nil)
        XCTAssertEqual(post.description, "# POST /v3/test\n\n+ Request (application/json)\n\n    + Body\n\n            {\n              \"foo\" : \"bar\"\n            }")
    }
    
}
