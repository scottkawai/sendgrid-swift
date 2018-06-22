//
//  SuppressionListReaderTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/21/17.
//

import XCTest
@testable import SendGrid

class SuppressionListReaderTests: XCTestCase {
    
    func testInitialization() {
        let email = SuppressionListReader<Bounce>(email: "foo@bar.com")
        XCTAssertNil(email.parameters!.startDate)
        XCTAssertNil(email.parameters!.endDate)
        XCTAssertNil(email.parameters!.page)
        XCTAssertEqual(email.path, "//foo@bar.com")
        
        let all = SuppressionListReader<Bounce>(start: Date(), end: Date(), page: Page(limit: 1, offset: 1))
        XCTAssertNotNil(all.parameters!.startDate)
        XCTAssertNotNil(all.parameters!.endDate)
        XCTAssertEqual(all.parameters!.page, Page(limit: 1, offset: 1))
        XCTAssertEqual(all.path, "/")
    }
    
}
