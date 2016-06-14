//
//  ClickTrackingTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest

class ClickTrackingTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitialization() {
        let basicOn = ClickTracking(enable: true)
        XCTAssertTrue(basicOn.enable)
        XCTAssertNil(basicOn.enableText)
        
        let basicOff = ClickTracking(enable: false)
        XCTAssertFalse(basicOff.enable)
        XCTAssertNil(basicOn.enableText)
        
        let complexOn = ClickTracking(enable: true, enablePlainText: false)
        XCTAssertTrue(complexOn.enable)
        XCTAssertFalse(complexOn.enableText!)
        
        let complexOff = ClickTracking(enable: false, enablePlainText: true)
        XCTAssertFalse(complexOff.enable)
        XCTAssertTrue(complexOff.enableText!)
    }
    
    func testJSONValue() {
        let basic = ClickTracking(enable: true)
        XCTAssertEqual(basic.jsonValue, "{\"click_tracking\":{\"enable\":true}}")
        
        let complex = ClickTracking(enable: false, enablePlainText: true)
        XCTAssertEqual(complex.jsonValue, "{\"click_tracking\":{\"enable_text\":true,\"enable\":false}}")
    }

}
