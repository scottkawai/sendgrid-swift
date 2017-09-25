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
        XCTAssertNil(email.startDate)
        XCTAssertNil(email.endDate)
        XCTAssertNil(email.page)
        XCTAssertEqual(email.endpoint?.path, "//foo@bar.com")
        
        let all = SuppressionListReader<Bounce>(start: Date(), end: Date(), page: Page(limit: 1, offset: 1))
        XCTAssertNotNil(all.startDate)
        XCTAssertNotNil(all.endDate)
        XCTAssertEqual(all.page, Page(limit: 1, offset: 1))
        XCTAssertEqual(all.endpoint?.path, "/")
    }
    
}
