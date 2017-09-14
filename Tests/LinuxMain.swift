import XCTest
@testable import SendGridTests

extension AddressTests {
    static var allTests : [(String, (AddressTests) -> () throws -> Void)] {
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
    testCase(AttachmentTests.allTests),
    testCase(ContentTests.allTests),
    testCase(AuthenticationTests.allTests),
    testCase(ContentTypeTests.allTests),
    testCase(ValidateTests.allTests)
])
