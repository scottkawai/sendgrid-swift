//
//  PersonalizationTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/15/17.
//

import XCTest
@testable import SendGrid

class PersonalizationTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = Personalization
    
    func testEncoding() {
        let basic = Personalization(recipients: "foo@example.none", "bar@example.none")
        XCTAssertEncodedObject(basic, equals: ["to": [["email": "foo@example.none"], ["email":"bar@example.none"]]])
        
        let complete = Personalization(
            to: [Address(email: "to@example.none", name: "To")],
            cc: [Address(email: "cc@example.none", name: "CC")],
            bcc: [Address(email: "bcc@example.none")],
            subject: "Hello World",
            headers: ["X-Foo": "Bar"],
            substitutions: ["%foo%": "bar"],
            customArguments: ["foo": "bar"]
        )
        complete.sendAt = Date(timeIntervalSince1970: 1505510705)
        let expected: [String : Any] = [
            "to": [
                [
                    "email": "to@example.none",
                    "name": "To"
                ]
            ],
            "cc": [
                [
                    "email": "cc@example.none",
                    "name": "CC"
                ]
            ],
            "bcc": [
                ["email": "bcc@example.none"]
            ],
            "subject": "Hello World",
            "headers": [
                "X-Foo": "Bar"
            ],
            "substitutions": ["%foo%": "bar"],
            "custom_args": ["foo":"bar"],
            "send_at": 1505510705
        ]
        XCTAssertEncodedObject(complete, equals: expected)
    }
    
}
