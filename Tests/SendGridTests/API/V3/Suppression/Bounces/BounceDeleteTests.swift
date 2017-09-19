//
//  BounceDeleteTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/19/17.
//

import XCTest
@testable import SendGrid

class BounceDeleteTests: XCTestCase {
    
    func testInitializer() {
        let request = Bounce.Delete(emails: "foo@example.none", "bar@example.none")
        let expectedBlueprint = """
        # DELETE /v3/suppression/bounces

        + Request (application/json)

            + Headers

                Accept: application/json

            + Body

                {
                  "emails" : [
                    "foo@example.none",
                    "bar@example.none"
                  ]
                }
        """
        XCTAssertEqual(request.description, expectedBlueprint)
    }
    
    func testDeleteAll() {
        let request = Bounce.Delete.all
        let expectedBlueprint = """
        # DELETE /v3/suppression/bounces

        + Request (application/json)

            + Headers

                Accept: application/json

            + Body

                {
                  "delete_all" : true
                }
        """
        XCTAssertEqual(request.description, expectedBlueprint)
    }
    
}
