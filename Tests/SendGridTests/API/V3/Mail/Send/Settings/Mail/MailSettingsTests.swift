@testable import SendGrid
import XCTest

class MailSettingsTests: XCTestCase, EncodingTester {
    typealias EncodableObject = MailSettings
    
    func testEncoding() {
        var settings = MailSettings()
        settings.bcc = BCCSetting(email: "foo@example.none")
        settings.bypassListManagement = BypassListManagement()
        settings.footer = Footer(text: "Hello World", html: "<p>Hello World</p>")
        settings.sandboxMode = SandboxMode()
        settings.spamCheck = SpamChecker(threshold: 8)
        let expected: [String: Any] = [
            "bcc": [
                "enable": true,
                "email": "foo@example.none"
            ],
            "bypass_list_management": ["enable": true],
            "footer": [
                "enable": true,
                "text": "Hello World",
                "html": "<p>Hello World</p>"
            ],
            "sandbox_mode": ["enable": true],
            "spam_check": [
                "enable": true,
                "threshold": 8
            ]
        ]
        XCTAssertEncodedObject(settings, equals: expected)
    }
    
    func testValidation() {
        var noErrors = MailSettings()
        XCTAssertNoThrow(try noErrors.validate())
        
        noErrors.bcc = BCCSetting(email: "foo@example.none")
        XCTAssertNoThrow(try noErrors.validate())
        
        noErrors.spamCheck = SpamChecker(threshold: 8)
        XCTAssertNoThrow(try noErrors.validate())
        
        do {
            var bccTest = MailSettings()
            bccTest.bcc = BCCSetting(email: "foo")
            try bccTest.validate()
        } catch let SendGrid.Exception.Mail.malformedEmailAddress(em) {
            XCTAssertEqual(em, "foo")
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            var spamTest = MailSettings()
            spamTest.spamCheck = SpamChecker(threshold: 815)
            try spamTest.validate()
        } catch let SendGrid.Exception.Mail.thresholdOutOfRange(i) {
            XCTAssertEqual(i, 815)
        } catch {
            XCTFailUnknownError(error)
        }
    }
}
