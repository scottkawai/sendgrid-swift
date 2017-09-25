//
//  EncodingTester.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/13/17.
//

import XCTest
@testable import SendGrid

protocol EncodingTester: class {
    
    associatedtype EncodableObject: Encodable
    
    func encode(_ obj: EncodableObject, strategy: EncodingStrategy) throws -> Data
    
    func XCTAssertEncodedObject(_ encodableObject: EncodableObject, equals dictionary: [String : Any])
    
    func XCTAssertDeepEquals(_ lhs: Any?, _ rhs: Any?)
    
}

extension EncodingTester {
    
    func encode(_ obj: EncodableObject, strategy: EncodingStrategy = EncodingStrategy()) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = strategy.data
        encoder.dateEncodingStrategy = strategy.dates
        return try encoder.encode(obj)
    }
    
    func XCTAssertEncodedObject(_ encodableObject: EncodableObject, equals dictionary: [String : Any]) {
        do {
            let json = try self.encode(encodableObject)
            guard let parsed = (try JSONSerialization.jsonObject(with: json)) as? [String : Any] else {
                XCTFail("Expected encoded object to be a dictionary, but received something else.")
                return
            }
            XCTAssertDeepEquals(parsed, dictionary)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func XCTAssertDeepEquals(_ lhs: Any?, _ rhs: Any?) {
        if let lDict = lhs as? [AnyHashable : Any], let rDict = rhs as? [AnyHashable : Any] {
            XCTAssertEqual(lDict.count, rDict.count)
            for (key, value) in lDict {
                XCTAssertDeepEquals(value, rDict[key])
            }
            for (key, value) in rDict {
                XCTAssertDeepEquals(value, lDict[key])
            }
        } else if let lArray = lhs as? [Any], let rArray = rhs as? [Any] {
            XCTAssertEqual(lArray.count, rArray.count)
            for item in lArray.enumerated() {
                XCTAssertDeepEquals(item.element, rArray[item.offset])
            }
        } else if let lBool = lhs as? Bool, let rBool = rhs as? Bool {
            XCTAssertEqual(lBool, rBool)
        } else if let left = lhs, let right = rhs {
            XCTAssertEqual("\(left)", "\(right)")
        } else {
            XCTAssertNotNil(lhs)
            XCTAssertNotNil(rhs)
        }
    }
    
}
