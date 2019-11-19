@testable import SendGrid
import XCTest

class EmailValidationResultTests: XCTestCase {
    func decode(json: String) throws -> EmailValidationResult {
        let decoder = JSONDecoder()
        return try decoder.decode(EmailValidationResult.self, from: Data(json.utf8))
    }
    
    func testDecoding() {
        do {
            let sample1 = """
            {
              "result": {
                "email": "foo@example.none",
                "verdict": "Invalid",
                "score": 0,
                "local": "foo",
                "host": "example.none",
                "checks": {
                  "domain": {
                    "has_valid_address_syntax": true,
                    "has_mx_or_a_record": false,
                    "is_suspected_disposable_address": false
                  },
                  "local_part": { "is_suspected_role_address": false },
                  "additional": {
                    "has_known_bounces": false,
                    "has_suspected_bounces": false
                  }
                },
                "ip_address": "123.45.67.89"
              }
            }
            """
            let result1 = try self.decode(json: sample1)
            XCTAssertEqual(result1.email, "foo@example.none")
            XCTAssertEqual(result1.verdict, .invalid)
            XCTAssertEqual(result1.score, 0)
            XCTAssertEqual(result1.local, "foo")
            XCTAssertEqual(result1.host, "example.none")
            XCTAssertNil(result1.suggestion)
            XCTAssertTrue(result1.checks.domain.hasValidAddressSyntax)
            XCTAssertFalse(result1.checks.domain.hasMxOrARecord)
            XCTAssertFalse(result1.checks.domain.isSuspectedDisposableAddress)
            XCTAssertFalse(result1.checks.localPart.isSuspectedRoleAddress)
            XCTAssertFalse(result1.checks.additional.hasKnownBounces)
            XCTAssertFalse(result1.checks.additional.hasSuspectedBounces)
            XCTAssertNil(result1.source)
            XCTAssertEqual(result1.ipAddress, "123.45.67.89")
        
            let sample2 = """
            {
              "result": {
                "email": "foo@gmial.com",
                "verdict": "Risky",
                "score": 0.00019,
                "local": "foo",
                "host": "gmial.com",
                "suggestion": "gmail.com",
                "checks": {
                  "domain": {
                    "has_valid_address_syntax": true,
                    "has_mx_or_a_record": true,
                    "is_suspected_disposable_address": false
                  },
                  "local_part": { "is_suspected_role_address": false },
                  "additional": {
                    "has_known_bounces": false,
                    "has_suspected_bounces": true
                  }
                },
                "source": "SIGN UP FORM"
              }
            }
            """
            let result2 = try self.decode(json: sample2)
            XCTAssertEqual(result2.email, "foo@gmial.com")
            XCTAssertEqual(result2.verdict, .risky)
            XCTAssertEqual(result2.score, 0.00019)
            XCTAssertEqual(result2.local, "foo")
            XCTAssertEqual(result2.host, "gmial.com")
            XCTAssertEqual(result2.suggestion, "gmail.com")
            XCTAssertTrue(result2.checks.domain.hasValidAddressSyntax)
            XCTAssertTrue(result2.checks.domain.hasMxOrARecord)
            XCTAssertFalse(result2.checks.domain.isSuspectedDisposableAddress)
            XCTAssertFalse(result2.checks.localPart.isSuspectedRoleAddress)
            XCTAssertFalse(result2.checks.additional.hasKnownBounces)
            XCTAssertTrue(result2.checks.additional.hasSuspectedBounces)
            XCTAssertEqual(result2.source, ValidateEmail.Source("Sign Up Form"))
            XCTAssertNil(result2.ipAddress)
            
            let sample3 = """
            {
              "result": {
                "email": "example",
                "verdict": "Invalid",
                "score": 0,
                "checks": {
                  "domain": {
                    "has_valid_address_syntax": false,
                    "has_mx_or_a_record": false,
                    "is_suspected_disposable_address": false
                  },
                  "local_part": { "is_suspected_role_address": false },
                  "additional": {
                    "has_known_bounces": false,
                    "has_suspected_bounces": false
                  }
                },
                "ip_address": "123.45.67.89"
              }
            }
            """
            let result3 = try self.decode(json: sample3)
            XCTAssertEqual(result3.email, "example")
            XCTAssertEqual(result3.verdict, .invalid)
            XCTAssertEqual(result3.score, 0)
            XCTAssertNil(result3.local)
            XCTAssertNil(result3.host)
            XCTAssertNil(result3.suggestion)
            XCTAssertFalse(result3.checks.domain.hasValidAddressSyntax)
            XCTAssertFalse(result3.checks.domain.hasMxOrARecord)
            XCTAssertFalse(result3.checks.domain.isSuspectedDisposableAddress)
            XCTAssertFalse(result3.checks.localPart.isSuspectedRoleAddress)
            XCTAssertFalse(result3.checks.additional.hasKnownBounces)
            XCTAssertFalse(result3.checks.additional.hasSuspectedBounces)
            XCTAssertNil(result3.source)
            XCTAssertEqual(result3.ipAddress, "123.45.67.89")
            
            let sample4 = """
            {
              "result": {
                "email": "foo@example.none",
                "verdict": "Valid",
                "score": 0.96598,
                "local": "foo",
                "host": "example.none",
                "checks": {
                  "domain": {
                    "has_valid_address_syntax": true,
                    "has_mx_or_a_record": true,
                    "is_suspected_disposable_address": false
                  },
                  "local_part": { "is_suspected_role_address": false },
                  "additional": {
                    "has_known_bounces": false,
                    "has_suspected_bounces": false
                  }
                },
                "ip_address": "123.45.67.89"
              }
            }
            """
            let result4 = try self.decode(json: sample4)
            XCTAssertEqual(result4.email, "foo@example.none")
            XCTAssertEqual(result4.verdict, .valid)
            XCTAssertEqual(result4.score, 0.96598)
            XCTAssertEqual(result4.local, "foo")
            XCTAssertEqual(result4.host, "example.none")
            XCTAssertNil(result4.suggestion)
            XCTAssertTrue(result4.checks.domain.hasValidAddressSyntax)
            XCTAssertTrue(result4.checks.domain.hasMxOrARecord)
            XCTAssertFalse(result4.checks.domain.isSuspectedDisposableAddress)
            XCTAssertFalse(result4.checks.localPart.isSuspectedRoleAddress)
            XCTAssertFalse(result4.checks.additional.hasKnownBounces)
            XCTAssertFalse(result4.checks.additional.hasSuspectedBounces)
            XCTAssertNil(result4.source)
            XCTAssertEqual(result4.ipAddress, "123.45.67.89")
        } catch {
            XCTFail("\(error)")
        }
    }
}
