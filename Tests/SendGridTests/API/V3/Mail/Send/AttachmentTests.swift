//
//  AttachmentTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/14/17.
//

import XCTest
@testable import SendGrid

class AttachmentTests: XCTestCase, EncodingTester {
    
    typealias EncodableObject = Attachment
    let redDotBytes: [UInt8] = [137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 5, 0, 0, 0, 5, 8, 6, 0, 0, 0, 141, 111, 38, 229, 0, 0, 0, 28, 73, 68, 65, 84, 8, 215, 99, 248, 255, 255, 63, 195, 127, 6, 32, 5, 195, 32, 18, 132, 208, 49, 241, 130, 88, 205, 4, 0, 14, 245, 53, 203, 209, 142, 14, 31, 0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130]
    
    func testEncoding() {
        let data = Data(bytes: self.redDotBytes)
        let minimalAttachment = Attachment(filename: "red.png", content: data)
        XCTAssertEncodedObject(minimalAttachment, equals: [
            "content": "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==",
            "filename": "red.png",
            "disposition": "attachment"
            ]
        )
        
        let maxAttachment = Attachment(filename: "red-dot.png", content: data, disposition: .inline, type: .png, contentID: "ABC-123")
        XCTAssertEncodedObject(maxAttachment, equals: [
            "content_id": "ABC-123",
            "content": "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==",
            "filename": "red-dot.png",
            "type": "image/png",
            "disposition": "inline"
            ]
        )
    }
    
}
