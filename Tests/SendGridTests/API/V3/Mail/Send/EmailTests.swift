@testable import SendGrid
import XCTest

class EmailTests: XCTestCase, EncodingTester {
    typealias EncodableObject = Email.Parameters
    
    let goodFrom = Address(email: "from@example.none")
    
    func generatePersonalizations(_ amount: Int) -> [Personalization] {
        Array(0..<amount).map { (i) -> Personalization in
            let recipient = Address(email: "test\(i)@example.none")
            return Personalization(to: [recipient])
        }
    }
    
    func generateBaseEmail(_ subject: String? = "Hello World") -> Email {
        let personalization = self.generatePersonalizations(1)
        return Email(
            personalizations: personalization,
            from: self.goodFrom,
            content: [Content.plainText(body: "plain")],
            subject: subject
        )
    }
    
    func testOnlyApiKeys() {
        do {
            let auth = try Authentication.credential(username: "foo", password: "bar")
            let session = Session(auth: auth)
            let goodContent = Content.emailBody(plain: "plain", html: "html")
            let email = Email(personalizations: self.generatePersonalizations(1), from: self.goodFrom, content: goodContent, subject: "Test")
            try session.send(request: email)
            XCTFail("Expected an error to be thrown when using basic auth with the mail send API, but nothing was thrown.")
        } catch let SendGrid.Exception.Session.unsupportedAuthetication(desc) {
            XCTAssertEqual(desc, "credential")
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
    func testNoImpersonation() {
        do {
            let auth = Authentication.apiKey("foobar")
            let session = Session(auth: auth, onBehalfOf: "baz")
            let goodContent = Content.emailBody(plain: "plain", html: "html")
            let email = Email(personalizations: self.generatePersonalizations(1), from: self.goodFrom, content: goodContent, subject: "Test")
            try session.send(request: email)
            XCTFail("Expected an error to be thrown when impersonating a subuser with the mail send API, but nothing was thrown.")
        } catch SendGrid.Exception.Session.impersonationNotAllowed {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
    func testEncoding() {
        let goodContent = Content.emailBody(plain: "plain", html: "html")
        let min = Email(personalizations: self.generatePersonalizations(1), from: self.goodFrom, content: goodContent)
        let minExpectations: [String: Any] = [
            "personalizations": [
                [
                    "to": [
                        [
                            "email": "test0@example.none"
                        ]
                    ]
                ]
            ],
            "from": [
                "email": "from@example.none"
            ],
            "content": [
                [
                    "type": "text/plain",
                    "value": "plain"
                ],
                [
                    "type": "text/html",
                    "value": "html"
                ]
            ]
        ]
        XCTAssertEncodedObject(min.parameters, equals: minExpectations)
        
        let max = Email(
            personalizations: self.generatePersonalizations(1),
            from: self.goodFrom,
            content: goodContent,
            subject: "Root Subject"
        )
        max.parameters.replyTo = "reply_to@example.none"
        let data = Data(AttachmentTests.redDotBytes)
        max.parameters.attachments = [Attachment(filename: "red.png", content: data)]
        max.parameters.templateID = "1334949C-CE58-4A21-A633-47638EFA358A"
        max.parameters.sections = [
            ":male": "Mr. :name",
            ":female": "Ms. :name",
            ":neutral": ":name",
            ":event1": "New User Event on :event_date",
            ":event2": "Veteran User Appreciation on :event_date"
        ]
        max.parameters.headers = [
            "Foo": "Bar"
        ]
        max.parameters.categories = ["Foo", "Bar"]
        max.parameters.customArguments = [
            "foo": "bar"
        ]
        max.parameters.sendAt = Date(timeIntervalSince1970: 1505705165)
        max.parameters.batchID = "foobar"
        max.parameters.asm = ASM(groupID: 1234)
        max.parameters.ipPoolName = "Marketing"
        max.parameters.mailSettings.sandboxMode = SandboxMode()
        max.parameters.trackingSettings.clickTracking = ClickTracking(section: .off)
        let maxExpectations: [String: Any] = [
            "personalizations": [
                [
                    "to": [
                        [
                            "email": "test0@example.none"
                        ]
                    ]
                ]
            ],
            "from": [
                "email": "from@example.none"
            ],
            "content": [
                [
                    "type": "text/plain",
                    "value": "plain"
                ],
                [
                    "type": "text/html",
                    "value": "html"
                ]
            ],
            "subject": "Root Subject",
            "reply_to": [
                "email": "reply_to@example.none"
            ],
            "attachments": [
                [
                    "content": AttachmentTests.dotBase64,
                    "filename": "red.png",
                    "disposition": "attachment"
                ]
            ],
            "template_id": "1334949C-CE58-4A21-A633-47638EFA358A",
            "sections": [
                ":male": "Mr. :name",
                ":female": "Ms. :name",
                ":neutral": ":name",
                ":event1": "New User Event on :event_date",
                ":event2": "Veteran User Appreciation on :event_date"
            ],
            "headers": [
                "Foo": "Bar"
            ],
            "categories": ["Foo", "Bar"],
            "custom_args": [
                "foo": "bar"
            ],
            "send_at": 1505705165,
            "batch_id": "foobar",
            "asm": [
                "group_id": 1234
            ],
            "ip_pool_name": "Marketing",
            "mail_settings": [
                "sandbox_mode": [
                    "enable": true
                ]
            ],
            "tracking_settings": [
                "click_tracking": [
                    "enable": false
                ]
            ]
        ]
        XCTAssertEncodedObject(max.parameters, equals: maxExpectations)
    }
    
    func testInitialization() {
        let personalization = self.generatePersonalizations(Constants.PersonalizationLimit)
        let goodContent = Content.emailBody(plain: "plain", html: "html")
        
        let good = Email(personalizations: personalization, from: self.goodFrom, content: goodContent)
        XCTAssertEqual(good.parameters.personalizations.count, Constants.PersonalizationLimit)
        XCTAssertEqual(good.parameters.personalizations[0].to[0].email, "test0@example.none")
        XCTAssertEqual(good.parameters.from.email, "from@example.none")
        XCTAssertEqual(good.parameters.content?.count, 2)
        XCTAssertEqual(good.parameters.content?[0].value, "plain")
        XCTAssertEqual(good.parameters.content?[1].value, "html")
        XCTAssertNil(good.parameters.subject)
    }
    
    func testPersonalizationValidation() {
        let goodContent = Content.emailBody(plain: "plain", html: "html")
        do {
            let empty = Email(personalizations: [], from: self.goodFrom, content: goodContent, subject: "Hello World")
            try empty.validate()
            XCTFail("Expected error to be thrown when initializing Email with an empty personalization array, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.invalidNumberOfPersonalizations {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let over = self.generatePersonalizations(Constants.PersonalizationLimit + 1)
            let tooMany = Email(personalizations: over, from: self.goodFrom, content: goodContent, subject: "Hello World")
            try tooMany.validate()
            XCTFail("Expected error to be thrown when providing more than \(Constants.PersonalizationLimit) personalizations, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.invalidNumberOfPersonalizations {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            // Over 1000 recipients should throw an error.
            let personalizations = Array(0...334).map(
                { (i) -> Personalization in
                    let to = Address(email: "to\(i)@example.none")
                    let cc = Address(email: "cc\(i)@example.none")
                    let bcc = Address(email: "bcc\(i)@example.none")
                    return Personalization(to: [to], cc: [cc], bcc: [bcc], subject: nil, headers: nil, substitutions: nil, customArguments: nil)
                }
            )
            let bad = Email(personalizations: personalizations, from: self.goodFrom, content: [Content.plainText(body: "uh oh")])
            try bad.validate()
            XCTFail("Expected an error to be thrown when an email contains more than \(Constants.RecipientLimit) total recipients, but nothing was thrown")
        } catch SendGrid.Exception.Mail.tooManyRecipients {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            // Under 1000 recipients should have no errors.
            let personalizations = Array(0...3).map(
                { (i) -> Personalization in
                    let to = Address(email: "to\(i)@example.none")
                    let cc = Address(email: "cc\(i)@example.none")
                    let bcc = Address(email: "bcc\(i)@example.none")
                    return Personalization(to: [to], cc: [cc], bcc: [bcc], subject: nil, headers: nil, substitutions: nil, customArguments: nil)
                }
            )
            let good = Email(personalizations: personalizations, from: self.goodFrom, content: [Content.plainText(body: "uh oh")], subject: "Hello World")
            try good.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let personalizations: [Personalization] = [
                Personalization(recipients: "test@example.none"),
                Personalization(to: [Address(email: "foo@bar.com")], cc: nil, bcc: [Address(email: "Test@example.none")], subject: "Hello", headers: nil, substitutions: nil, customArguments: nil)
            ]
            let bad = Email(personalizations: personalizations, from: self.goodFrom, content: [Content.plainText(body: "uh oh")])
            try bad.validate()
            XCTFail("Expected an error to be thrown when an email is listed more than once in the personalizations array, but nothing was thrown.")
        } catch let SendGrid.Exception.Mail.duplicateRecipient(duplicate) {
            XCTAssertEqual(duplicate, "test@example.none")
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let personalizations: [Personalization] = [
                Personalization(recipients: "test@example.none"),
                Personalization(to: [Address(email: "foo@bar.com")], cc: [Address(email: "Test@example.none")], bcc: nil, subject: "Hello", headers: nil, substitutions: nil, customArguments: nil)
            ]
            let bad = Email(personalizations: personalizations, from: self.goodFrom, content: [Content.plainText(body: "uh oh")])
            try bad.validate()
            XCTFail("Expected an error to be thrown when an email is listed more than once in the personalizations array, but nothing was thrown.")
        } catch let SendGrid.Exception.Mail.duplicateRecipient(duplicate) {
            XCTAssertEqual(duplicate, "test@example.none")
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let personalizations: [Personalization] = [
                Personalization(recipients: "test@example.none"),
                Personalization(recipients: "test@example.none")
            ]
            let bad = Email(personalizations: personalizations, from: self.goodFrom, content: [Content.plainText(body: "uh oh")])
            try bad.validate()
            XCTFail("Expected an error to be thrown when an email is listed more than once in the personalizations array, but nothing was thrown.")
        } catch let SendGrid.Exception.Mail.duplicateRecipient(duplicate) {
            XCTAssertEqual(duplicate, "test@example.none")
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let personalizations: [Personalization] = [Personalization(recipients: "test@example.none")]
            let fromTest = Email(personalizations: personalizations, from: Address(email: "from"), content: [Content.plainText(body: "uh oh")], subject: "Hello World")
            try fromTest.validate()
            XCTFail("Expected error to be thrown when an email has a malformed From address, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.malformedEmailAddress(_) {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let personalizations: [Personalization] = [Personalization(recipients: "test@example.none")]
            let replyToTest = Email(personalizations: personalizations, from: self.goodFrom, content: [Content.plainText(body: "uh oh")], subject: "Hello World")
            replyToTest.parameters.replyTo = "reply"
            try replyToTest.validate()
            XCTFail("Expected error to be thrown when an email has a malformed Reply To address, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.malformedEmailAddress(_) {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
    func testContentValidation() {
        let personalization = self.generatePersonalizations(Constants.PersonalizationLimit)
        let plain = Content.plainText(body: "plain")
        let html = Content.html(body: "html")
        let csv = Content(contentType: .csv, value: "foo,bar")
        let amp = Content(contentType: .amp, value: "AMP")
        let goodContent = [plain, html]
        
        do {
            let empty = Email(personalizations: personalization, from: self.goodFrom, content: [], subject: "Hello World")
            try empty.validate()
            XCTFail("Expected error to be thrown when initializing Email with an empty content array, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.missingContent {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        let badContent1 = [csv] + goodContent
        do {
            let badOrder = Email(personalizations: personalization, from: self.goodFrom, content: badContent1, subject: "Hello World")
            try badOrder.validate()
            XCTFail("Expected error to be thrown when providing an out of order content array, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.invalidContentOrder {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        let badContent2 = [plain, csv, html]
        do {
            let badOrder2 = Email(personalizations: personalization, from: self.goodFrom, content: badContent2, subject: "Hello World")
            try badOrder2.validate()
            XCTFail("Expected error to be thrown when providing an out of order content array, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.invalidContentOrder {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        let badContent3 = [html, plain, csv]
        do {
            let badOrder3 = Email(personalizations: personalization, from: self.goodFrom, content: badContent3, subject: "Hello World")
            try badOrder3.validate()
            XCTFail("Expected error to be thrown when providing an out of order content array, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.invalidContentOrder {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let goodOrder = Email(personalizations: personalization, from: self.goodFrom, content: [plain, html, csv], subject: "Hello World")
            try goodOrder.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let goodOrderAMP1 = Email(personalizations: personalization, from: self.goodFrom, content: [plain, html, amp], subject: "Hello World")
            try goodOrderAMP1.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let goodOrderAMP2 = Email(personalizations: personalization, from: self.goodFrom, content: [plain, amp, html], subject: "Hello World")
            try goodOrderAMP2.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let badOrderAMP = Email(personalizations: personalization, from: self.goodFrom, content: [amp, plain, html], subject: "Hello World")
            try badOrderAMP.validate()
            XCTFail("Expected error to be thrown when providing an out of order content array, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.invalidContentOrder {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        /// No content with no template ID should throw an error.
        do {
            let personalization = Personalization(recipients: "test@example.none")
            let noContentEmail = Email(personalizations: [personalization], from: self.goodFrom, content: [], subject: "Hello world")
            noContentEmail.parameters.content = nil
            try noContentEmail.validate()
        } catch SendGrid.Exception.Mail.missingContent {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        /// Empty array content with no template ID should throw an error.
        do {
            let personalization = Personalization(recipients: "test@example.none")
            let emptyContentEmail = Email(personalizations: [personalization], from: self.goodFrom, content: [], subject: "Hello world")
            try emptyContentEmail.validate()
        } catch SendGrid.Exception.Mail.missingContent {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        /// No content with a template ID throws no error.
        do {
            let personalization = Personalization(recipients: "test@example.none")
            let emptyTemplatedEmail = Email(personalizations: [personalization], from: self.goodFrom, templateID: "ABCDEFG", subject: "Hello world")
            XCTAssertNoThrow(try emptyTemplatedEmail.validate())
        }
        
        /// Empty array content with a template ID throws no error.
        do {
            let personalization = Personalization(recipients: "test@example.none")
            let emptyTemplatedEmail = Email(personalizations: [personalization], from: self.goodFrom, templateID: "ABCDEFG", subject: "Hello world")
            emptyTemplatedEmail.parameters.content = []
            XCTAssertNoThrow(try emptyTemplatedEmail.validate())
        }
        
        /// Content with a template ID throws no error.
        do {
            let personalization = Personalization(recipients: "test@example.none")
            let templatedEmail = Email(personalizations: [personalization], from: self.goodFrom, templateID: "ABCDEFG", subject: "Hello world")
            templatedEmail.parameters.content = Content.emailBody(plain: "foobar", html: "<p>foobar</p>")
            XCTAssertNoThrow(try templatedEmail.validate())
        }
    }
    
    func testSubjectValidation() {
        do {
            let missing = self.generateBaseEmail(nil)
            try missing.validate()
            XCTFail("Expected an error to be thrown when a subject is missing, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.missingSubject {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let missing = self.generateBaseEmail("")
            try missing.validate()
            XCTFail("Expected an error to be thrown when a subject is an empty, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.missingSubject {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let personalizations = [
                Personalization(to: [Address(email: "recipient1@example.none")], cc: nil, bcc: nil, subject: "Subject 1", headers: nil, substitutions: nil, customArguments: nil),
                Personalization(recipients: "recipient2@example.none")
            ]
            let missing = Email(personalizations: personalizations, from: Address(email: "from@example.none"), content: Content.emailBody(plain: "plain", html: "html"))
            try missing.validate()
            XCTFail("Expected an error to be thrown when a subject is not set as global, and not present in a personalization, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.missingSubject {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let personalizations = [
                Personalization(to: [Address(email: "recipient1@example.none")], cc: nil, bcc: nil, subject: "", headers: nil, substitutions: nil, customArguments: nil)
            ]
            let missing = Email(personalizations: personalizations, from: Address(email: "from@example.none"), content: Content.emailBody(plain: "plain", html: "html"))
            try missing.validate()
            XCTFail("Expected an error to be thrown when a subject is not set as global, and an empty string in a personalization, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.missingSubject {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            // No error should be thrown when each personalization has a subject line.
            let personalizations = [
                Personalization(to: [Address(email: "recipient1@example.none")], cc: nil, bcc: nil, subject: "Subject 1", headers: nil, substitutions: nil, customArguments: nil),
                Personalization(to: [Address(email: "recipient2@example.none")], cc: nil, bcc: nil, subject: "Subject 2", headers: nil, substitutions: nil, customArguments: nil)
            ]
            let valid = Email(personalizations: personalizations, from: Address(email: "from@example.none"), content: Content.emailBody(plain: "plain", html: "html"))
            try valid.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            // No error should be thrown if all subject properties are `nil` and a template ID is specified.
            let personalizations = [
                Personalization(recipients: "recipient1@example.none"),
                Personalization(recipients: "recipient2@example.none")
            ]
            let valid = Email(personalizations: personalizations, from: Address(email: "from@example.none"), content: Content.emailBody(plain: "plain", html: "html"))
            valid.parameters.templateID = "696DC347-E82F-44EB-8CB1-59320BA1F136"
            try valid.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
    func testHeaderValidation() {
        do {
            let good = self.generateBaseEmail()
            good.parameters.headers = [
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
            bad.parameters.headers = [
                "X-Custom-Header": "Foo",
                "subject": "12345"
            ]
            try bad.validate()
            XCTFail("Expected error when using a reserved header, but no error was thrown")
        } catch let SendGrid.Exception.Mail.headerNotAllowed(header) {
            XCTAssertEqual(header, "subject")
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let bad = self.generateBaseEmail()
            bad.parameters.headers = [
                "X-Custom Header": "Foo"
            ]
            try bad.validate()
            XCTFail("Expected error when using a header with a space, but no error was thrown")
        } catch let SendGrid.Exception.Mail.malformedHeader(header) {
            XCTAssertEqual(header, "X-Custom Header")
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
    func testCategoryValidation() {
        do {
            let good = self.generateBaseEmail()
            good.parameters.categories = ["Category1", "Category2", "Category3", "Category4", "Category5", "Category6", "Category7", "Category8", "Category9", "Category10"]
            try good.validate()
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let good = self.generateBaseEmail()
            good.parameters.categories = ["Category1", "Category2", "Category3", "Category4", "Category5", "Category6", "Category7", "Category8", "Category9", "category3"]
            try good.validate()
            XCTFail("Expected error when there are duplicate categories, but nothing was thrown.")
        } catch let SendGrid.Exception.Mail.duplicateCategory(dupe) {
            XCTAssertEqual(dupe, "category3")
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let bad = self.generateBaseEmail()
            bad.parameters.categories = ["Category1", "Category2", "Category3", "Category4", "Category5", "Category6", "Category7", "Category8", "Category9", "Category10", "Category11"]
            try bad.validate()
            XCTFail("Expected error when there are too many categories, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.tooManyCategories {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        let characters = Array(0..<200).map { "\($0)" }
        let longCategory = characters.joined(separator: "")
        do {
            let bad = self.generateBaseEmail()
            bad.parameters.categories = [longCategory]
            try bad.validate()
            XCTFail("Expected error when a category name is too long, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.categoryTooLong(_) {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
    func testCustomArgs() {
        let email = self.generateBaseEmail()
        email.parameters.customArguments = ["foo": "bar"]
        XCTAssertEqual(email.parameters.customArguments!["foo"], "bar")
        
        let new = Personalization(recipients: "test@example.none")
        new.customArguments = ["foo": "bar"]
        let over = Email(personalizations: [new], from: self.goodFrom, content: [Content.plainText(body: "plain")], subject: "Custom Args")
        var args = [String: String]()
        for i in 0..<300 {
            args["custom_arg_\(i)"] = "custom value \(i)"
        }
        over.parameters.customArguments = args
        do {
            try over.validate()
            XCTFail("Expected an error when the custom arguments exceed \(Constants.CustomArguments.MaximumBytes) bytes, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.tooManyCustomArguments(_, _) {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
    func testSendAt() {
        let test = self.generateBaseEmail()
        let goodDate = Date(timeIntervalSinceNow: 4 * 60 * 60)
        test.parameters.sendAt = goodDate
        do {
            try test.validate()
            XCTAssertEqual(test.parameters.sendAt?.timeIntervalSince1970, goodDate.timeIntervalSince1970)
        } catch SendGrid.Exception.Mail.invalidScheduleDate {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        let failTest = self.generateBaseEmail()
        let badDate = Date(timeIntervalSinceNow: 80 * 60 * 60)
        failTest.parameters.sendAt = badDate
        do {
            try failTest.validate()
            XCTFail("Expected a failure when scheduling a date further than 72 hours out, but nothing was thrown.")
        } catch SendGrid.Exception.Mail.invalidScheduleDate {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
}
