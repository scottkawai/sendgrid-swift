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
    
}
