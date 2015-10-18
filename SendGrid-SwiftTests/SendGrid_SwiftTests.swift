//
//  SendGrid_SwiftTests.swift
//  SendGrid-SwiftTests
//
//  Created by Scott Kawai on 10/24/14.
//  Copyright (c) 2014 SendGrid. All rights reserved.
//

import Cocoa
import XCTest

class SendGrid_SwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddToWithoutSmtpApi() {
        let email = SendGrid.Email()
        email.hasRecipientsInSmtpApi = false
        try! email.addTo("isaac@test.none", name: "Isaac")
        try! email.addTo("jose@test.none", name: "Jose")
        if let tos = email.to {
            XCTAssertEqual(tos[0], "isaac@test.none", "addTo added an email to the to property")
            XCTAssertEqual(tos[1], "jose@test.none", "addTo added a second email to the to property")
            if let names = email.toname {
                XCTAssertEqual(names[0], "Isaac", "addTo added a to name to the toname property")
                XCTAssertEqual(names[1], "Jose", "addTo added a second to name to the toname property")
            } else {
                XCTFail("addTo did not create an array for tonames (`toname` is nil).")
            }
        } else {
            XCTFail("addTo did not create an array (`to` is nil).")
        }
    }
    
}
