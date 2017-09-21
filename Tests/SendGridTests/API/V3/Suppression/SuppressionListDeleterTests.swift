//
//  SuppressionListDeleterTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/21/17.
//

import XCTest
@testable import SendGrid

class SuppressionListDeleterTests: XCTestCase {
    
    func testInitialization() {
        let deleteAllOn = SuppressionListDeleter<Bounce>(deleteAll: true, emails: nil)
        XCTAssertTrue(deleteAllOn.deleteAll!)
        XCTAssertNil(deleteAllOn.emails)
        
        let deleteAllOff = SuppressionListDeleter<Bounce>(deleteAll: false, emails: nil)
        XCTAssertFalse(deleteAllOff.deleteAll!)
        XCTAssertNil(deleteAllOff.emails)
        
        let emails = SuppressionListDeleter<Bounce>(deleteAll: nil, emails: ["foo@bar.com"])
        XCTAssertNil(emails.deleteAll)
        XCTAssertEqual(emails.emails?.joined(), "foo@bar.com")
    }
    
}
