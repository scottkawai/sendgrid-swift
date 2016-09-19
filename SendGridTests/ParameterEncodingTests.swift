//
//  ParameterEncodingTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/20/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest
@testable import SendGrid

class ParameterEncodingTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFormURLEncoded() {
        // Should result in `foo=one&bar=two`
        let goodParams = ["foo":"one", "bar":"two"]
        XCTAssertEqual(ParameterEncoding.formUrlEncodedString(from: goodParams), "foo=one&bar=two")
        // Should return nil if not provided a dictionary.
        let badParams = ["foo", "bar"]
        XCTAssertNil(ParameterEncoding.formUrlEncodedData(from: badParams))
    }

}
