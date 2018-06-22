//
//  DeleteBlocksTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/19/17.
//

import XCTest
@testable import SendGrid

class DeleteBlocksTests: XCTestCase {
    
    func testInitializer() {
        let request = DeleteBlocks(emails: "foo@example.none", "bar@example.none")
        XCTAssertEqual(request.description, "")
    }
    
    func testDeleteAll() {
        let request = DeleteBlocks.all
        XCTAssertEqual(request.description, "")
    }
    
}
