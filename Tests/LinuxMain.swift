import XCTest
@testable import SendGridTests

extension BlockTests {
    static var allTests : [(String, (BlockTests) -> () throws -> Void)] {
        return [
            ("testInitialization", testInitialization)
        ]
    }
}


extension BounceTests {
    static var allTests : [(String, (BounceTests) -> () throws -> Void)] {
        return [
            ("testInitialization", testInitialization)
        ]
    }
}


extension GlobalUnsubscribeTests {
    static var allTests : [(String, (GlobalUnsubscribeTests) -> () throws -> Void)] {
        return [
            ("testInitialization", testInitialization)
        ]
    }
}


extension InvalidEmailTests {
    static var allTests : [(String, (InvalidEmailTests) -> () throws -> Void)] {
        return [
            ("testInitialization", testInitialization)
        ]
    }
}


extension SpamReportTests {
    static var allTests : [(String, (SpamReportTests) -> () throws -> Void)] {
        return [
            ("testInitialization", testInitialization)
        ]
    }
}


extension AddressTests {
    static var allTests : [(String, (AddressTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding),
            ("testInitialization", testInitialization),
            ("testValidation", testValidation)
        ]
    }
}


extension ASMTests {
    static var allTests : [(String, (ASMTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding),
            ("testInitialization", testInitialization),
            ("testValidation", testValidation)
        ]
    }
}


extension AttachmentTests {
    static var allTests : [(String, (AttachmentTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding),
            ("testInitialization", testInitialization),
            ("testValidation", testValidation)
        ]
    }
}


extension ContentTests {
    static var allTests : [(String, (ContentTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding),
            ("testInitialization", testInitialization),
            ("testClassInitializers", testClassInitializers),
            ("testValidation", testValidation)
        ]
    }
}


extension EmailTests {
    static var allTests : [(String, (EmailTests) -> () throws -> Void)] {
        return [
            ("testOnlyApiKeys", testOnlyApiKeys),
            ("testNoImpersonation", testNoImpersonation),
            ("testEncoding", testEncoding),
            ("testInitialization", testInitialization),
            ("testPersonalizationValidation", testPersonalizationValidation),
            ("testContentValidation", testContentValidation),
            ("testSubjectValidation", testSubjectValidation),
            ("testHeaderValidation", testHeaderValidation),
            ("testCategoryValidation", testCategoryValidation),
            ("testCustomArgs", testCustomArgs),
            ("testSendAt", testSendAt)
        ]
    }
}


extension PersonalizationTests {
    static var allTests : [(String, (PersonalizationTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding),
            ("testInitialization", testInitialization),
            ("testValidation", testValidation)
        ]
    }
}


extension BCCSettingTests {
    static var allTests : [(String, (BCCSettingTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding),
            ("testValidation", testValidation)
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
            ("testEncoding", testEncoding),
            ("testValidation", testValidation)
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
            ("testEncoding", testEncoding),
            ("testInitialization", testInitialization),
            ("testValidation", testValidation)
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


extension SubscriptionTrackingTests {
    static var allTests : [(String, (SubscriptionTrackingTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding),
            ("testValidation", testValidation)
        ]
    }
}


extension TrackingSettingsTests {
    static var allTests : [(String, (TrackingSettingsTests) -> () throws -> Void)] {
        return [
            ("testEncoding", testEncoding),
            ("testValidation", testValidation)
        ]
    }
}


extension RetrieveCategoryStatisticsTests {
    static var allTests : [(String, (RetrieveCategoryStatisticsTests) -> () throws -> Void)] {
        return [
            ("testMinimalInitialization", testMinimalInitialization),
            ("testMaxInitialization", testMaxInitialization),
            ("testValidation", testValidation)
        ]
    }
}


extension RetrieveGlobalStatisticsTests {
    static var allTests : [(String, (RetrieveGlobalStatisticsTests) -> () throws -> Void)] {
        return [
            ("testMinimalInitialization", testMinimalInitialization),
            ("testMaxInitialization", testMaxInitialization),
            ("testValidation", testValidation)
        ]
    }
}


extension RetrieveSubuserStatisticsTests {
    static var allTests : [(String, (RetrieveSubuserStatisticsTests) -> () throws -> Void)] {
        return [
            ("testMinimalInitialization", testMinimalInitialization),
            ("testMaxInitialization", testMaxInitialization),
            ("testValidation", testValidation)
        ]
    }
}


extension RetrieveSubusersTests {
    static var allTests : [(String, (RetrieveSubusersTests) -> () throws -> Void)] {
        return [
            ("testInitialization", testInitialization),
            ("testValidation", testValidation)
        ]
    }
}


extension DeleteBlocksTests {
    static var allTests : [(String, (DeleteBlocksTests) -> () throws -> Void)] {
        return [
            ("testInitializer", testInitializer),
            ("testDeleteAll", testDeleteAll)
        ]
    }
}


extension RetrieveBlocksTests {
    static var allTests : [(String, (RetrieveBlocksTests) -> () throws -> Void)] {
        return [
            ("testGetAllInitialization", testGetAllInitialization),
            ("testEmailSpecificInitializer", testEmailSpecificInitializer),
            ("testValidation", testValidation)
        ]
    }
}


extension DeleteBouncesTests {
    static var allTests : [(String, (DeleteBouncesTests) -> () throws -> Void)] {
        return [
            ("testInitializer", testInitializer),
            ("testDeleteAll", testDeleteAll)
        ]
    }
}


extension RetrieveBouncesTests {
    static var allTests : [(String, (RetrieveBouncesTests) -> () throws -> Void)] {
        return [
            ("testGetAllInitialization", testGetAllInitialization),
            ("testEmailSpecificInitializer", testEmailSpecificInitializer),
            ("testValidation", testValidation)
        ]
    }
}


extension AddGlobalUnsubscribesTests {
    static var allTests : [(String, (AddGlobalUnsubscribesTests) -> () throws -> Void)] {
        return [
            ("testInitialization", testInitialization)
        ]
    }
}


extension DeleteGlobalUnsubscribeTests {
    static var allTests : [(String, (DeleteGlobalUnsubscribeTests) -> () throws -> Void)] {
        return [
            ("testInitializer", testInitializer)
        ]
    }
}


extension RetrieveGlobalUnsubscribesTests {
    static var allTests : [(String, (RetrieveGlobalUnsubscribesTests) -> () throws -> Void)] {
        return [
            ("testGetAllInitialization", testGetAllInitialization),
            ("testEmailSpecificInitializer", testEmailSpecificInitializer),
            ("testValidation", testValidation)
        ]
    }
}


extension DeleteInvalidEmailsTests {
    static var allTests : [(String, (DeleteInvalidEmailsTests) -> () throws -> Void)] {
        return [
            ("testInitializer", testInitializer),
            ("testDeleteAll", testDeleteAll)
        ]
    }
}


extension RetrieveInvalidEmailsTests {
    static var allTests : [(String, (RetrieveInvalidEmailsTests) -> () throws -> Void)] {
        return [
            ("testGetAllInitialization", testGetAllInitialization),
            ("testEmailSpecificInitializer", testEmailSpecificInitializer),
            ("testValidation", testValidation)
        ]
    }
}


extension DeleteSpamReportsTests {
    static var allTests : [(String, (DeleteSpamReportsTests) -> () throws -> Void)] {
        return [
            ("testInitializer", testInitializer),
            ("testDeleteAll", testDeleteAll)
        ]
    }
}


extension RetrieveSpamReportsTests {
    static var allTests : [(String, (RetrieveSpamReportsTests) -> () throws -> Void)] {
        return [
            ("testGetAllInitialization", testGetAllInitialization),
            ("testEmailSpecificInitializer", testEmailSpecificInitializer),
            ("testValidation", testValidation)
        ]
    }
}


extension SuppressionListDeleterTests {
    static var allTests : [(String, (SuppressionListDeleterTests) -> () throws -> Void)] {
        return [
            ("testInitialization", testInitialization)
        ]
    }
}


extension SuppressionListReaderTests {
    static var allTests : [(String, (SuppressionListReaderTests) -> () throws -> Void)] {
        return [
            ("testInitialization", testInitialization)
        ]
    }
}


extension SessionTests {
    static var allTests : [(String, (SessionTests) -> () throws -> Void)] {
        return [
            ("testSendWithoutAuth", testSendWithoutAuth)
        ]
    }
}


extension HTTPMethodTests {
    static var allTests : [(String, (HTTPMethodTests) -> () throws -> Void)] {
        return [
            ("testDescription", testDescription),
            ("testHasBody", testHasBody)
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


extension PaginationTests {
    static var allTests : [(String, (PaginationTests) -> () throws -> Void)] {
        return [
            ("testStaticInitializer", testStaticInitializer),
            ("testNoHeader", testNoHeader),
            ("testBadHeaders", testBadHeaders)
        ]
    }
}


extension RateLimitTests {
    static var allTests : [(String, (RateLimitTests) -> () throws -> Void)] {
        return [
            ("testStaticInitializer", testStaticInitializer),
            ("testBadHeaders", testBadHeaders)
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
    testCase(BlockTests.allTests),
    testCase(BounceTests.allTests),
    testCase(GlobalUnsubscribeTests.allTests),
    testCase(InvalidEmailTests.allTests),
    testCase(SpamReportTests.allTests),
    testCase(AddressTests.allTests),
    testCase(ASMTests.allTests),
    testCase(AttachmentTests.allTests),
    testCase(ContentTests.allTests),
    testCase(EmailTests.allTests),
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
    testCase(SubscriptionTrackingTests.allTests),
    testCase(TrackingSettingsTests.allTests),
    testCase(RetrieveCategoryStatisticsTests.allTests),
    testCase(RetrieveGlobalStatisticsTests.allTests),
    testCase(RetrieveSubuserStatisticsTests.allTests),
    testCase(RetrieveSubusersTests.allTests),
    testCase(DeleteBlocksTests.allTests),
    testCase(RetrieveBlocksTests.allTests),
    testCase(DeleteBouncesTests.allTests),
    testCase(RetrieveBouncesTests.allTests),
    testCase(AddGlobalUnsubscribesTests.allTests),
    testCase(DeleteGlobalUnsubscribeTests.allTests),
    testCase(RetrieveGlobalUnsubscribesTests.allTests),
    testCase(DeleteInvalidEmailsTests.allTests),
    testCase(RetrieveInvalidEmailsTests.allTests),
    testCase(DeleteSpamReportsTests.allTests),
    testCase(RetrieveSpamReportsTests.allTests),
    testCase(SuppressionListDeleterTests.allTests),
    testCase(SuppressionListReaderTests.allTests),
    testCase(SessionTests.allTests),
    testCase(HTTPMethodTests.allTests),
    testCase(AuthenticationTests.allTests),
    testCase(ContentTypeTests.allTests),
    testCase(PaginationTests.allTests),
    testCase(RateLimitTests.allTests),
    testCase(ValidateTests.allTests)
])
