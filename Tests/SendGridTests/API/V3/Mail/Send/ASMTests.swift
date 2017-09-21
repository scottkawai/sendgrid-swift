//
//  ASMTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/15/17.
//

import XCTest
@testable import SendGrid

class ASMTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = ASM
    
    func testEncoding() {
        let min = ASM(groupID: 4)
        XCTAssertEncodedObject(min, equals: ["group_id": 4])
        
        let max = ASM(groupID: 4, groupsToDisplay: [8, 15, 16, 23, 42])
        XCTAssertEncodedObject(max, equals: ["group_id": 4, "groups_to_display": [8, 15, 16, 23, 42]])
    }
    
    func testInitialization() {
        let basic = ASM(groupID: 4)
        XCTAssertEqual(basic.id, 4)
        XCTAssertNil(basic.groupsToDisplay)
        
        let advance = ASM(groupID: 4, groupsToDisplay: [8, 15, 16, 23, 42])
        XCTAssertEqual(advance.id, 4)
        XCTAssertEqual(advance.groupsToDisplay!, [8, 15, 16, 23, 42])
    }
    
    func testValidation() {
        let over = ASM(groupID: 815, groupsToDisplay: Array(1...3))
        XCTAssertNoThrow(try over.validate())
        
        do {
            let over = ASM(groupID: 815, groupsToDisplay: Array(1...30))
            try over.validate()
            XCTFail("Expected an error to be thrown when `ASM` is provided more than \(Constants.UnsubscribeGroups.MaximumNumberOfDisplayGroups) groups to display, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SendGrid.Exception.Mail.tooManyUnsubscribeGroups.description)
        }
    }
    
}
