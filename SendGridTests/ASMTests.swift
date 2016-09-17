//
//  ASMTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/17/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest
@testable import SendGrid

class ASMTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        let basic = ASM(groupID: 4)
        XCTAssertEqual(basic.id, 4)
        XCTAssertNil(basic.groupsToDisplay)
        
        let advance = ASM(groupID: 4, groupsToDisplay: [8, 15, 16, 23, 42])
        XCTAssertEqual(advance.id, 4)
        XCTAssertEqual(advance.groupsToDisplay!, [8, 15, 16, 23, 42])
    }
    
    func testJSONValue() {
        let basic = ASM(groupID: 4)
        XCTAssertEqual(basic.jsonValue, "{\"asm\":{\"group_id\":4}}")
        
        let advance = ASM(groupID: 4, groupsToDisplay: [8, 15, 16, 23, 42])
        XCTAssertEqual(advance.jsonValue, "{\"asm\":{\"groups_to_display\":[8,15,16,23,42],\"group_id\":4}}")
    }
    
    func testValidation() {
        do {
            var tooMany: [Int] = []
            for i in 0...30 {
                tooMany.append(i)
            }
            let over = ASM(groupID: 815, groupsToDisplay: tooMany)
            try over.validate()
            XCTFail("Expected an error to be thrown when `ASM` is provided more than \(Constants.UnsubscribeGroups.MaximumNumberOfDisplayGroups) groups to display, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.tooManyUnsubscribeGroups.description)
        }
    }
}
