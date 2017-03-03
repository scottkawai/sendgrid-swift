//
//  BypassListManagementTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest
@testable import SendGrid

class BypassListManagementTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitialization() {
        let setting = BypassListManagement(enable: true)
        XCTAssertTrue(setting.enable)
    }

    func testJSONValue() {
        let setting = BypassListManagement(enable: false)
        XCTAssertEqual(setting.jsonValue, "{\"bypass_list_management\":{\"enable\":false}}")
    }

}
