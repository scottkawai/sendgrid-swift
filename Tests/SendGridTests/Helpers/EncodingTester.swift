//
//  EncodingTester.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/13/17.
//

import XCTest

protocol EncodingTester: class {
    
    associatedtype EncodableObject: Encodable
    
    func encode(_ obj: EncodableObject) throws -> Data
    
    func XCTAssert(encodableObject: EncodableObject, equals dictionary: [String : Any])
    
}

extension EncodingTester {
    
    func encode(_ obj: EncodableObject) throws -> Data {
        return try JSONEncoder().encode(obj)
    }
    
    func XCTAssert(encodableObject: EncodableObject, equals dictionary: [String : Any]) {
        do {
            let json = try self.encode(encodableObject)
            guard let parsed = (try JSONSerialization.jsonObject(with: json)) as? [String : Any] else {
                XCTFail("Expected encoded object to be a dictionary, but received something else.")
                return
            }
            for (key, value) in dictionary {
                guard let val = parsed[key] else {
                    XCTAssertNotNil(parsed[key])
                    continue
                }
                XCTAssertEqual("\(val)", "\(value)")
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
}
