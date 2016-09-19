//
//  OpenTrackingTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest
@testable import SendGrid

class OpenTrackingTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitialization() {
        let basicOn = OpenTracking(enable: true)
        XCTAssertTrue(basicOn.enable)
        XCTAssertNil(basicOn.substitutionTag)
        
        let basicOff = OpenTracking(enable: false)
        XCTAssertFalse(basicOff.enable)
        XCTAssertNil(basicOn.substitutionTag)
        
        let complex = OpenTracking(enable: true, substitutionTag: "%open%")
        XCTAssertTrue(complex.enable)
        XCTAssertEqual(complex.substitutionTag, "%open%")
    }
    
    func testJSONValue() {
        let basic = OpenTracking(enable: true)
        XCTAssertEqual(basic.jsonValue, "{\"open_tracking\":{\"enable\":true}}")
        
        let complex = OpenTracking(enable: false, substitutionTag: "%open%")
        XCTAssertEqual(complex.jsonValue, "{\"open_tracking\":{\"substitution_tag\":\"%open%\",\"enable\":false}}")
    }

}
