import XCTest
@testable import SendGridTests

extension AddressTests {
    static var allTests : [(String, (AddressTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension ASMTests {
    static var allTests : [(String, (ASMTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension AttachmentTests {
    static var allTests : [(String, (AttachmentTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension ContentTests {
    static var allTests : [(String, (ContentTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension PersonalizationTests {
    static var allTests : [(String, (PersonalizationTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension BCCSettingTests {
    static var allTests : [(String, (BCCSettingTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension BypassListManagementTests {
    static var allTests : [(String, (BypassListManagementTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension FooterTests {
    static var allTests : [(String, (FooterTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension MailSettingsTests {
    static var allTests : [(String, (MailSettingsTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension SandboxModeTests {
    static var allTests : [(String, (SandboxModeTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension SpamCheckerTests {
    static var allTests : [(String, (SpamCheckerTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension ClickTrackingTests {
    static var allTests : [(String, (ClickTrackingTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample)
        ]
    }
}


extension GoogleAnalyticsTests {
    static var allTests : [(String, (GoogleAnalyticsTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension OpenTrackingTests {
    static var allTests : [(String, (OpenTrackingTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension TrackingSettingTests {
    static var allTests : [(String, (TrackingSettingTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding)
        ]
    }
}


extension AuthenticationTests {
    static var allTests : [(String, (AuthenticationTests) -> () throws -> Void)] {
        return [
            ("testInitializer", testInitializer),
            ("testAuthorizationHeader", testAuthorizationHeader),
            ("testApiKey", testApiKey),
            ("testCredential", testCredential)
        ]
    }
}


extension ContentTypeTests {
    static var allTests : [(String, (ContentTypeTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding),
            ("testInitializerAndDescription", testInitializerAndDescription),
            ("testRawInitializer", testRawInitializer),
            ("testIndex", testIndex)
        ]
    }
}


extension ValidateTests {
    static var allTests : [(String, (ValidateTests) -> () throws -> Void)] {
        return [
            ("testInput", testInput),
            ("testEmail", testEmail),
            ("testSubscriptionTracking", testSubscriptionTracking),
            ("testNoCLRF", testNoCLRF)
        ]
    }
}


XCTMain([
    testCase(AddressTests.allTests),
    testCase(ASMTests.allTests),
    testCase(AttachmentTests.allTests),
    testCase(ContentTests.allTests),
    testCase(PersonalizationTests.allTests),
    testCase(BCCSettingTests.allTests),
    testCase(BypassListManagementTests.allTests),
    testCase(FooterTests.allTests),
    testCase(MailSettingsTests.allTests),
    testCase(SandboxModeTests.allTests),
    testCase(SpamCheckerTests.allTests),
    testCase(ClickTrackingTests.allTests),
    testCase(GoogleAnalyticsTests.allTests),
    testCase(OpenTrackingTests.allTests),
    testCase(TrackingSettingTests.allTests),
    testCase(AuthenticationTests.allTests),
    testCase(ContentTypeTests.allTests),
    testCase(ValidateTests.allTests)
])
