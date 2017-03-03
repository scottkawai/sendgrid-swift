//
//  JSONConvertibleTests.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/17/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import XCTest
@testable import SendGrid

class JSONConvertibleTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSerialization() {
        struct Good: JSONConvertible {
            fileprivate var dictionaryValue: [AnyHashable: Any] {
                return ["foo":"bar"]
            }
        }
        
        struct Bad: JSONConvertible {
            fileprivate var dictionaryValue: [AnyHashable: Any] {
                return ["test":Date()]
            }
        }
        
        let g = Good()
        let b = Bad()
        
        XCTAssertEqual(g.jsonValue, "{\"foo\":\"bar\"}")
        XCTAssertNil(b.jsonValue)
    }

}
