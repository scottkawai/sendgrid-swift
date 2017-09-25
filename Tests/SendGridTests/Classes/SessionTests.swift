//
//  SessionTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/18/17.
//

import XCTest
@testable import SendGrid

class SessionTests: XCTestCase {
    
    func testSendWithoutAuth() {
        let session = Session()
        let personalization = [Personalization(recipients: "test@example.com")]
        let email = Email(personalizations: personalization, from: Address(email: "foo@bar.com"), content: [Content.plainText(body: "plain")], subject: "Hello World")
        do {
            try session.send(request: email)
            XCTFail("Expected failure when sending a request without authentication, but nothing was thrown.")
        } catch SendGrid.Exception.Session.authenticationMissing {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}
