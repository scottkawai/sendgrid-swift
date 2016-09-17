//
//  EmailTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/17/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest
@testable import SendGrid

class EmailTests: XCTestCase {
    
    let goodFrom = Address(emailAddress: "from@example.com")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func generatePersonalizations(_ amount: Int) -> [Personalization] {
        var list: [Personalization] = []
        for i in 0..<amount {
            let recipient = Address(emailAddress: "test\(i)@example.com")
            list.append(Personalization(to: [recipient]))
        }
        return list
    }
    
    func generateBaseEmail(_ subject: String? = "Hello World") -> Email {
        let personalization = self.generatePersonalizations(1)
        return Email(personalizations: personalization, from: self.goodFrom, content: [Content.plainTextContent("plain")], subject: subject)
    }
    
    func testInitialization() {
        let personalization = self.generatePersonalizations(Constants.PersonalizationLimit)
        let goodContent = Content.emailContent(plain: "plain", html: "html")
        
        let good = Email(personalizations: personalization, from: self.goodFrom, content: goodContent)
        XCTAssertEqual(good.personalizations.count, Constants.PersonalizationLimit)
        XCTAssertEqual(good.personalizations[0].to[0].email, "test0@example.com")
        XCTAssertEqual(good.from.email, "from@example.com")
        XCTAssertEqual(good.content.count, 2)
        XCTAssertEqual(good.content[0].value, "plain")
        XCTAssertEqual(good.content[1].value, "html")
        XCTAssertNil(good.subject)
    }
    
    func testPersonalizationValidation() {
        let goodContent = Content.emailContent(plain: "plain", html: "html")
        do {
            let empty = Email(personalizations: [], from: self.goodFrom, content: goodContent, subject: "Hello World")
            try empty.validate()
            XCTFail("Expected error to be thrown when initializing Email with an empty personalization array, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.invalidNumberOfPersonalizations.description)
        }
        
        do {
            let over = self.generatePersonalizations(Constants.PersonalizationLimit + 1)
            let tooMany = Email(personalizations: over, from: self.goodFrom, content: goodContent, subject: "Hello World")
            try tooMany.validate()
            XCTFail("Expected error to be thrown when providing more than \(Constants.PersonalizationLimit) personalizations, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.invalidNumberOfPersonalizations.description)
        }
        
        do {
            // Over 1000 recipients should throw an error.
            var personalizations: [Personalization] = []
            for i in 0...334 {
                let to = Address(emailAddress: "to\(i)@example.com")
                let cc = Address(emailAddress: "cc\(i)@example.com")
                let bcc = Address(emailAddress: "bcc\(i)@example.com")
                let entry = Personalization(to: [to], cc: [cc], bcc: [bcc], subject: nil, headers: nil, substitutions: nil, customArguments: nil)
                personalizations.append(entry)
            }
            let bad = Email(personalizations: personalizations, from: self.goodFrom, content: [Content.plainTextContent("uh oh")])
            try bad.validate()
            XCTFail("Expected an error to be thrown when an email contains more than \(Constants.RecipientLimit) total recipients, but nothing was thrown")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.tooManyRecipients.description)
        }
        
        do {
            // Under 1000 recipients should have no errors.
            var personalizations: [Personalization] = []
            for i in 0...3 {
                let to = Address(emailAddress: "to\(i)@example.com")
                let cc = Address(emailAddress: "cc\(i)@example.com")
                let bcc = Address(emailAddress: "bcc\(i)@example.com")
                let entry = Personalization(to: [to], cc: [cc], bcc: [bcc], subject: nil, headers: nil, substitutions: nil, customArguments: nil)
                personalizations.append(entry)
            }
            let good = Email(personalizations: personalizations, from: self.goodFrom, content: [Content.plainTextContent("uh oh")], subject: "Hello World")
            try good.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        do {
            let personalizations: [Personalization] = [
                Personalization(recipients: "test@example.com"),
                Personalization(to: [Address(emailAddress:"foo@bar.com")], cc: nil, bcc: [Address(emailAddress: "Test@example.com")], subject: "Hello", headers: nil, substitutions: nil, customArguments: nil)
            ]
            let bad = Email(personalizations: personalizations, from: self.goodFrom, content: [Content.plainTextContent("uh oh")])
            try bad.validate()
            XCTFail("Expected an error to be thrown when an email is listed more than once in the personalizations array, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.duplicateRecipient("Test@example.com").description)
        }
        
        do {
            let personalizations: [Personalization] = [
                Personalization(recipients: "test@example.com"),
                Personalization(to: [Address(emailAddress:"foo@bar.com")], cc: [Address(emailAddress: "Test@example.com")], bcc: nil, subject: "Hello", headers: nil, substitutions: nil, customArguments: nil)
            ]
            let bad = Email(personalizations: personalizations, from: self.goodFrom, content: [Content.plainTextContent("uh oh")])
            try bad.validate()
            XCTFail("Expected an error to be thrown when an email is listed more than once in the personalizations array, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.duplicateRecipient("Test@example.com").description)
        }
        
        do {
            let personalizations: [Personalization] = [
                Personalization(recipients: "test@example.com"),
                Personalization(recipients: "test@example.com")
            ]
            let bad = Email(personalizations: personalizations, from: self.goodFrom, content: [Content.plainTextContent("uh oh")])
            try bad.validate()
            XCTFail("Expected an error to be thrown when an email is listed more than once in the personalizations array, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.duplicateRecipient("test@example.com").description)
        }
        
        do {
            let personalizations: [Personalization] = [Personalization(recipients: "test@example.com")]
            let fromTest = Email(personalizations: personalizations, from: Address(emailAddress: "from"), content: [Content.plainTextContent("uh oh")], subject: "Hello World")
            try fromTest.validate()
            XCTFail("Expected error to be thrown when an email has a malformed From address, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.malformedEmailAddress("from").description)
        }
        
        do {
            let personalizations: [Personalization] = [Personalization(recipients: "test@example.com")]
            let replyToTest = Email(personalizations: personalizations, from: self.goodFrom, content: [Content.plainTextContent("uh oh")], subject: "Hello World")
            replyToTest.replyTo = Address(emailAddress: "reply")
            try replyToTest.validate()
            XCTFail("Expected error to be thrown when an email has a malformed Reply To address, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.malformedEmailAddress("reply").description)
        }
    }
    
    func testContentValidation() {
        let personalization = self.generatePersonalizations(Constants.PersonalizationLimit)
        let plain = Content.plainTextContent("plain")
        let html = Content.htmlContent("html")
        let csv = Content(contentType: ContentType.csv, value: "foo,bar")
        let goodContent = [plain, html]
        
        do {
            let empty = Email(personalizations: personalization, from: self.goodFrom, content: [], subject: "Hello World")
            try empty.validate()
            XCTFail("Expected error to be thrown when initializing Email with an empty content array, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.missingContent.description)
        }
        
        let badContent1 = [csv] + goodContent
        do {
            let badOrder = Email(personalizations: personalization, from: self.goodFrom, content: badContent1, subject: "Hello World")
            try badOrder.validate()
            XCTFail("Expected error to be thrown when providing an out of order content array, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.invalidContentOrder.description)
        }
        
        let badContent2 = [plain, csv, html]
        do {
            let badOrder2 = Email(personalizations: personalization, from: self.goodFrom, content: badContent2, subject: "Hello World")
            try badOrder2.validate()
            XCTFail("Expected error to be thrown when providing an out of order content array, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.invalidContentOrder.description)
        }
        
        let badContent3 = [html, plain, csv]
        do {
            let badOrder3 = Email(personalizations: personalization, from: self.goodFrom, content: badContent3, subject: "Hello World")
            try badOrder3.validate()
            XCTFail("Expected error to be thrown when providing an out of order content array, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.invalidContentOrder.description)
        }
    }
    
    func testSubjectValidation() {
        do {
            let missing = self.generateBaseEmail(nil)
            try missing.validate()
            XCTFail("Expected an error to be thrown when a subject is missing, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.missingSubject.description)
        }
        
        do {
            let missing = self.generateBaseEmail("")
            try missing.validate()
            XCTFail("Expected an error to be thrown when a subject is an empty, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.missingSubject.description)
        }
        
        do {
            let personalizations = [
                Personalization(to: [Address(emailAddress: "recipient1@example.com")], cc: nil, bcc: nil, subject: "Subject 1", headers: nil, substitutions: nil, customArguments: nil),
                Personalization(recipients: "recipient2@example.com")
            ]
            let missing = Email(personalizations: personalizations, from: Address(emailAddress: "from@example.com"), content: Content.emailContent(plain: "plain", html: "html"))
            try missing.validate()
            XCTFail("Expected an error to be thrown when a subject is not set as global, and not present in a personalization, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.missingSubject.description)
        }
        
        do {
            let personalizations = [
                Personalization(to: [Address(emailAddress: "recipient1@example.com")], cc: nil, bcc: nil, subject: "", headers: nil, substitutions: nil, customArguments: nil),
                ]
            let missing = Email(personalizations: personalizations, from: Address(emailAddress: "from@example.com"), content: Content.emailContent(plain: "plain", html: "html"))
            try missing.validate()
            XCTFail("Expected an error to be thrown when a subject is not set as global, and an empty string in a personalization, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.missingSubject.description)
        }
        
        do {
            // No error should be thrown when each personalization has a subject line.
            let personalizations = [
                Personalization(to: [Address(emailAddress: "recipient1@example.com")], cc: nil, bcc: nil, subject: "Subject 1", headers: nil, substitutions: nil, customArguments: nil),
                Personalization(to: [Address(emailAddress: "recipient2@example.com")], cc: nil, bcc: nil, subject: "Subject 2", headers: nil, substitutions: nil, customArguments: nil),
                ]
            let valid = Email(personalizations: personalizations, from: Address(emailAddress: "from@example.com"), content: Content.emailContent(plain: "plain", html: "html"))
            try valid.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        do {
            // No error should be thrown if all subject properties are `nil` and a template ID is specified.
            let personalizations = [
                Personalization(recipients: "recipient1@example.com"),
                Personalization(recipients: "recipient2@example.com")
            ]
            let valid = Email(personalizations: personalizations, from: Address(emailAddress: "from@example.com"), content: Content.emailContent(plain: "plain", html: "html"))
            valid.templateID = "696DC347-E82F-44EB-8CB1-59320BA1F136"
            try valid.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testHeaderValidation() {
        do {
            let good = self.generateBaseEmail()
            good.headers = [
                "X-Custom-Header": "Foo",
                "X-UID": "12345"
            ]
            try good.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        do {
            let bad = self.generateBaseEmail()
            bad.headers = [
                "X-Custom-Header": "Foo",
                "subject": "12345"
            ]
            try bad.validate()
            XCTFail("Expected error when using a reserved header, but no error was thrown")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.headerNotAllowed("subject").description)
        }
        
        do {
            let bad = self.generateBaseEmail()
            bad.headers = [
                "X-Custom Header": "Foo"
            ]
            try bad.validate()
            XCTFail("Expected error when using a header with a space, but no error was thrown")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.malformedHeader("X-Custom Header").description)
        }
    }
    
    func testCategoryValidation() {
        do {
            let good = self.generateBaseEmail()
            good.categories = ["Category1", "Category2", "Category3", "Category4", "Category5", "Category6", "Category7", "Category8", "Category9", "Category10"]
            try good.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        do {
            let bad = self.generateBaseEmail()
            bad.categories = ["Category1", "Category2", "Category3", "Category4", "Category5", "Category6", "Category7", "Category8", "Category9", "Category10", "Category11"]
            try bad.validate()
            XCTFail("Expected error when there are too many categories, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.tooManyCategories.description)
        }
        
        var characters: [String] = []
        for i in 0..<200 {
            characters.append("\(i)")
        }
        let longCategory = characters.joined(separator: "")
        do {
            let bad = self.generateBaseEmail()
            bad.categories = [longCategory]
            try bad.validate()
            XCTFail("Expected error when a category name is too long, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.categoryTooLong(longCategory).description)
        }
    }
    
    func testBaseJSONValue() {
        let email = self.generateBaseEmail()
        XCTAssertEqual(email.jsonValue, "{\"subject\":\"Hello World\",\"content\":[{\"value\":\"plain\",\"type\":\"text\\/plain\"}],\"personalizations\":[{\"to\":[{\"email\":\"test0@example.com\"}]}],\"from\":{\"email\":\"from@example.com\"}}")
    }
    
    func testSubject() {
        let email = self.generateBaseEmail()
        XCTAssertEqual(email.subject, "Hello World")
        XCTAssertTrue(email.jsonValue!.contains("\"subject\":\"Hello World\""))
    }
    
    func testReplyTo() {
        let email = self.generateBaseEmail()
        email.replyTo = Address(emailAddress: "replyto@example.com")
        XCTAssertEqual(email.replyTo?.email, "replyto@example.com")
        XCTAssertTrue(email.jsonValue!.contains("\"reply_to\":{\"email\":\"replyto@example.com\"}"))
    }
    
    func testTemplateID() {
        let email = self.generateBaseEmail()
        email.templateID = "B8554A44-249C-4E95-B499-ED189003F7A4"
        XCTAssertEqual(email.templateID, "B8554A44-249C-4E95-B499-ED189003F7A4")
        XCTAssertTrue(email.jsonValue!.contains("\"template_id\":\"B8554A44-249C-4E95-B499-ED189003F7A4\""))
    }
    
    func testHeaders() {
        let email = self.generateBaseEmail()
        email.headers = [
            "X-CUSTOM-HEADER": "FOO"
        ]
        XCTAssertEqual(email.headers!["X-CUSTOM-HEADER"], "FOO")
        XCTAssertTrue(email.jsonValue!.contains("\"headers\":{\"X-CUSTOM-HEADER\":\"FOO\"}"))
    }
    
    func testMailSettings() {
        let email = self.generateBaseEmail()
        email.mailSettings = [BypassListManagement(enable: true)]
        XCTAssertTrue(email.jsonValue!.contains("\"mail_settings\":{\"bypass_list_management\":{\"enable\":true}}"))
    }
    
    func testTrackingSettings() {
        let email = self.generateBaseEmail()
        email.trackingSettings = [ClickTracking(enable: true)]
        XCTAssertTrue(email.jsonValue!.contains("\"tracking_settings\":{\"click_tracking\":{\"enable\":true}}"))
    }
    
    func testCategories() {
        let email = self.generateBaseEmail()
        email.categories = [
            "Foo",
            "Foobar",
            "Foo",
            "Bar",
        ]
        XCTAssertEqual(email.categories?.first, "Foo")
        XCTAssertEqual(email.categories?.last, "Bar")
        XCTAssertTrue(email.jsonValue!.contains("\"categories\":[\"Foo\",\"Foobar\",\"Bar\"]"))
    }
    
    func testAttachments() {
        if let path = Bundle(for: type(of: self)).pathForImageResource("dot.png"), let image = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let email = self.generateBaseEmail()
            email.attachments = [Attachment(filename: "dot.png", content: image)]
            XCTAssertEqual(email.attachments?.count, 1)
            XCTAssertEqual(email.attachments?[0].filename, "dot.png")
            XCTAssertTrue(email.jsonValue!.contains("\"attachments\":["))
            XCTAssertTrue(email.jsonValue!.contains("\"filename\":\"dot.png\""))
            XCTAssertTrue(email.jsonValue!.contains("\"content\":\"iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4\\/\\/8\\/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==\""))
        } else {
            XCTFail("Unable to load dot.png for EmailTests.testAttachments()")
        }
    }
    
    func testSections() {
        let email = self.generateBaseEmail()
        email.sections = ["foo":"bar"]
        XCTAssertEqual(email.sections?["foo"], "bar")
        XCTAssertTrue(email.jsonValue!.contains("\"sections\":{\"foo\":\"bar\"}"))
    }
    
    func testCustomArgs() {
        let email = self.generateBaseEmail()
        email.customArguments = ["foo":"bar"]
        XCTAssertEqual(email.customArguments?["foo"], "bar")
        XCTAssertTrue(email.jsonValue!.contains("\"custom_args\":{\"foo\":\"bar\"}"))
        
        let new = Personalization(recipients: "test@example.com")
        new.customArguments = ["foo":"bar"]
        let over = Email(personalizations: [new], from: self.goodFrom, content: [Content.plainTextContent("plain")], subject: "Custom Args")
        var args = [String:String]()
        for i in 0..<300 {
            args["custom_arg_\(i)"] = "custom value \(i)"
        }
        over.customArguments = args
        do {
            try over.validate()
            XCTFail("Expected an error when the custom arguments exceed \(Constants.CustomArguments.MaximumBytes) bytes, but nothing was thrown.")
        } catch {
            XCTAssertTrue("\(error)".contains("Each personalized email cannot have custom arguments exceeding \(Constants.CustomArguments.MaximumBytes) bytes"))
        }
    }
    
    func testSendAt() {
        let test = self.generateBaseEmail()
        let goodDate = Date(timeIntervalSinceNow: 4 * 60 * 60)
        test.sendAt = goodDate
        do {
            try test.validate()
            XCTAssertEqual(test.sendAt?.timeIntervalSince1970, goodDate.timeIntervalSince1970)
            XCTAssertTrue(test.jsonValue!.contains("\"send_at\":\(Int(goodDate.timeIntervalSince1970))"))
        } catch {
            XCTFail("Unexpected failure when scheduling with a date under 72 hours.")
        }
        
        let failTest = self.generateBaseEmail()
        let badDate = Date(timeIntervalSinceNow: 80 * 60 * 60)
        failTest.sendAt = badDate
        do {
            try failTest.validate()
            XCTFail("Expected a failure when scheduling a date further than 72 hours out, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Mail.invalidScheduleDate.description)
        }
        
    }
    
    func testBatchID() {
        let email = self.generateBaseEmail()
        XCTAssertNil(email.batchID)
        email.batchID = "9B0C3B9C-F0DE-4979-87FF-B11566A447FC"
        XCTAssertEqual(email.batchID, "9B0C3B9C-F0DE-4979-87FF-B11566A447FC")
        XCTAssertTrue(email.jsonValue!.contains("\"batch_id\":\"9B0C3B9C-F0DE-4979-87FF-B11566A447FC\""))
    }
    
    func testIpPoolName() {
        let email = self.generateBaseEmail()
        XCTAssertNil(email.ipPoolName)
        email.ipPoolName = "Transactional"
        XCTAssertTrue(email.jsonValue!.contains("\"ip_pool_name\":\"Transactional\""))
    }
    
    func testRequestForSession() {
        let test = self.generateBaseEmail()
        test.asm = ASM(groupID: 1)
        do {
            let creds = Session(auth: Authentication.credential(username: "foo", password: "bar"))
            try creds.send(test)
            XCTFail("Expected error to be thrown when using the mail send API with credentials, but nothing was thrown")
        } catch {
            XCTAssertEqual("\(error)", "The `Email` class does not allow authentication with credentials. Please try using another Authentication type.")
        }
        
        do {
            let creds = Session.sharedInstance
            creds.authentication = Authentication.apiKey("asdf")
            let expectation = self.expectation(description: "Test Send")
            try creds.send(test, onComplete: { (response, error) in
                XCTAssertTrue(true)
                expectation.fulfill()
            })
            
            waitForExpectations(timeout: 10, handler: { (err) in
                if let e = err { print(e) }
            })
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        // An error should be thrown if a subuser was provided.
        
        do {
            let s = Session(auth: Authentication.apiKey("SG.abcdefghijklmnop.qrstuvwxyz012345-6789"))
            _ = try test.requestForSession(s, onBehalfOf: "foobar")
            XCTFail("Expected an error to be thrown when a subuser username is provided in the `onBehalfOf` parameter, but nothing was thrown.")
        } catch {
            XCTAssertEqual("\(error)", SGError.Request.impersonationNotSupported(Email.self).description)
        }
    }
}
