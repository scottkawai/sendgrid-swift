//
//  SandboxModeTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest

class SandboxModeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitialization() {
        let setting = SandboxMode(enable: true)
        XCTAssertTrue(setting.enable)
    }
    
    func testJSONValue() {
        let setting = SandboxMode(enable: false)
        XCTAssertEqual(setting.jsonValue, "{\"sandbox_mode\":{\"enable\":false}}")
    }

}
