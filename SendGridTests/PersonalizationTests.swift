//
//  PersonalizationTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest
@testable import SendGrid

class PersonalizationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func generateRecipients(_ amount: Int = 1, prefix: String = "person") -> [Address] {
        var list: [Address] = []
        for i in 0..<amount {
            let number = i + 1
            let email = "\(prefix.lowercased())\(number)@example.com"
            list.append(Address(emailAddress: email))
        }
        return list
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
        
        let good = Personalization(recipients: "test1@example.com", "test2@example.com")
        XCTAssertEqual(good.to.count, 2)
        XCTAssertEqual(good.to[0].email, "test1@example.com")
        XCTAssertEqual(good.to[1].email, "test2@example.com")
    }
    
    func testValidation() {
        do {
            let missing = Personalization(to: [])
            try missing.validate()
            XCTFail("Expected error to be thrown when providing an empty array of to addresses, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.missingRecipients.description)
        }
        
        do {
            let cc = self.generateExample()
            cc.cc = [Address(emailAddress: "cc")]
            try cc.validate()
            XCTFail("Expected error to be thrown when providing an empty array of to addresses, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.malformedEmailAddress("cc").description)
        }
        
        do {
            let bcc = self.generateExample()
            bcc.bcc = [Address(emailAddress: "bcc")]
            try bcc.validate()
            XCTFail("Expected error to be thrown when providing an empty array of to addresses, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.malformedEmailAddress("bcc").description)
        }
        
        do {
            let badTo = Personalization(recipients: "test")
            try badTo.validate()
            XCTFail("Expected error to be thrown when providing a malformed email address, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.malformedEmailAddress("test").description)
        }
        
        let test = self.generateExample()
        XCTAssertNil(test.sendAt)
        let goodDate = Date(timeIntervalSinceNow: 4 * 60 * 60)
        test.sendAt = goodDate
        do {
            try test.validate()
            XCTAssertEqual(test.sendAt?.timeIntervalSince1970, goodDate.timeIntervalSince1970)
            XCTAssertTrue(test.jsonValue!.contains("\"send_at\":\(Int(goodDate.timeIntervalSince1970))"))
        } catch {
            XCTFail("Unexpected failure when scheduling with a date under 72 hours.")
        }
        
        let failTest = self.generateExample()
        let badDate = Date(timeIntervalSinceNow: 80 * 60 * 60)
        failTest.sendAt = badDate
        do {
            try failTest.validate()
            XCTFail("Expected a failure when scheduling a date further than 72 hours out, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.invalidScheduleDate.description)
        }
        
        do {
            let bad = Personalization(recipients: "test1@example.com")
            bad.headers = [
                "X-CUSTOM": "FOO",
                "bcc": "test2@example.com"
            ]
            try bad.validate()
            XCTFail("Expected error to be thrown when using a reserved header, but nothing was thrown")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.headerNotAllowed("bcc").description)
        }
        
        do {
            let goodSubstitutions = self.generateExample(false)
            try goodSubstitutions.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error: \(error)")
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
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.tooManySubstitutions.description)
        }
    }
    
    func testJSONValue() {
        let simple = self.generateExample()
        XCTAssertEqual(simple.jsonValue, "{\"to\":[{\"email\":\"recipient1@example.com\"},{\"email\":\"recipient2@example.com\"}]}")
        let now = Date()
        simple.sendAt = now
        XCTAssertEqual(simple.jsonValue, "{\"send_at\":\(Int(now.timeIntervalSince1970)),\"to\":[{\"email\":\"recipient1@example.com\"},{\"email\":\"recipient2@example.com\"}]}")
        
        let complex = self.generateExample(false)
        XCTAssertEqual(complex.jsonValue, "{\"subject\":\"This is a test\",\"headers\":{\"X-Test\":\"Pass\"},\"to\":[{\"email\":\"recipient1@example.com\"},{\"email\":\"recipient2@example.com\"}],\"bcc\":[{\"email\":\"blind_copy1@example.com\"},{\"email\":\"blind_copy2@example.com\"}],\"substitutions\":{\"%foo%\":\"%bar%\"},\"custom_args\":{\"uid\":\"12345\"},\"cc\":[{\"email\":\"copy1@example.com\"},{\"email\":\"copy2@example.com\"}]}")
    }
    
}
