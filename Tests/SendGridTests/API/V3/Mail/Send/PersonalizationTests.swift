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
    
    func generateRecipients(_ amount: Int = 1, prefix: String = "person") -> [Address] {
        return Array(1...amount).map({ (i) -> Address in
            let email = "\(prefix.lowercased())\(i)@example.none"
            return Address(email: email)
        })
    }
    
    func generateExample(_ isSimple: Bool = true) -> Personalization {
        let recipients = self.generateRecipients(2, prefix: "recipient")
        if isSimple {
            return Personalization(to: recipients)
        } else {
            let ccs = self.generateRecipients(2, prefix: "copy")
            let bccs = self.generateRecipients(2, prefix: "blind_copy")
            return Personalization(
                to: recipients,
                cc: ccs,
                bcc: bccs,
                subject: "This is a test",
                headers: ["X-Test":"Pass"],
                substitutions: ["%foo%":"%bar%"],
                customArguments: ["uid":"12345"]
            )
        }
    }
    
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
            customArguments: ["foo": "bar"],
            sendAt: Date(timeIntervalSince1970: 1505510705)
        )
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
    
    func testInitialization() {
        let recipients = self.generateRecipients(2, prefix: "recipient")
        let simple = self.generateExample()
        for i in 0..<2 {
            XCTAssertEqual(simple.to[i].email, recipients[i].email)
        }
        XCTAssertNil(simple.cc)
        XCTAssertNil(simple.bcc)
        XCTAssertNil(simple.subject)
        XCTAssertNil(simple.headers)
        XCTAssertNil(simple.substitutions)
        XCTAssertNil(simple.customArguments)
        XCTAssertNil(simple.sendAt)
        
        let ccs = self.generateRecipients(2, prefix: "copy")
        let bccs = self.generateRecipients(2, prefix: "blind_copy")
        let complex = self.generateExample(false)
        for i in 0..<2 {
            XCTAssertEqual(complex.to[i].email, recipients[i].email)
        }
        for i in 0..<2 {
            XCTAssertEqual(complex.cc?[i].email, ccs[i].email)
        }
        for i in 0..<2 {
            XCTAssertEqual(complex.bcc?[i].email, bccs[i].email)
        }
        XCTAssertEqual(complex.subject, "This is a test")
        XCTAssertEqual(complex.headers?["X-Test"], "Pass")
        XCTAssertEqual(complex.substitutions?["%foo%"], "%bar%")
        XCTAssertEqual(complex.customArguments?["uid"], "12345")
        XCTAssertNil(complex.sendAt)
        
        let good = Personalization(recipients: "test1@example.none", "test2@example.none")
        XCTAssertEqual(good.to.count, 2)
        XCTAssertEqual(good.to[0].email, "test1@example.none")
        XCTAssertEqual(good.to[1].email, "test2@example.none")
    }
    
    func testValidation() {
        do {
            let missing = Personalization(to: [])
            try missing.validate()
            XCTFail("Expected error to be thrown when providing an empty array of to addresses, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.missingRecipients {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let cc = self.generateExample()
            cc.cc = [Address(email: "cc")]
            try cc.validate()
            XCTFail("Expected error to be thrown when providing an empty array of to addresses, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.malformedEmailAddress(_) {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let bcc = self.generateExample()
            bcc.bcc = [Address(email: "bcc")]
            try bcc.validate()
            XCTFail("Expected error to be thrown when providing an empty array of to addresses, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.malformedEmailAddress(_) {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let badTo = Personalization(recipients: "test")
            try badTo.validate()
            XCTFail("Expected error to be thrown when providing a malformed email address, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.malformedEmailAddress(_) {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        let test = self.generateExample()
        XCTAssertNil(test.sendAt)
        let goodDate = Date(timeIntervalSinceNow: 4 * 60 * 60)
        test.sendAt = goodDate
        do {
            try test.validate()
            XCTAssertEqual(test.sendAt?.timeIntervalSince1970, goodDate.timeIntervalSince1970)
        } catch {
            XCTFailUnknownError(error)
        }
        
        let failTest = self.generateExample()
        let badDate = Date(timeIntervalSinceNow: 80 * 60 * 60)
        failTest.sendAt = badDate
        do {
            try failTest.validate()
            XCTFail("Expected a failure when scheduling a date further than 72 hours out, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.invalidScheduleDate {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let bad = Personalization(recipients: "test1@example.none")
            bad.headers = [
                "X-CUSTOM": "FOO",
                "bcc": "test2@example.none"
            ]
            try bad.validate()
            XCTFail("Expected error to be thrown when using a reserved header, but nothing was thrown")
        } catch SendGrid.Exception.Mail.headerNotAllowed(_) {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let goodSubstitutions = self.generateExample(false)
            try goodSubstitutions.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let tooManySubs = self.generateExample()
            var subs: [String:String] = [:]
            for i in 0...Constants.SubstitutionLimit {
                subs["key\(i)"] = "value\(i)"
            }
            tooManySubs.substitutions = subs
            try tooManySubs.validate()
            XCTFail("Expected failure when there are more than \(Constants.SubstitutionLimit) substitutions, but nothing was thrown")
        } catch SendGrid.Exception.Mail.tooManySubstitutions {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}
