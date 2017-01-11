//
//  HeaderValidator.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/19/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `HeaderValidator` protocol provides a method for ensuring custom headers are valid.
 
 */
public protocol HeaderValidator {
    /**
     
     Validates a set of headers to ensure they are not using any reserved headers. If there is a problem, an error is thrown. If everything is fine, then this method returns nothing.
     
     - parameter headers:	A dictionary representing the header names and values.
     
     */
    func validate(headers: [String:String]) throws
}

public extension HeaderValidator {
    /**
     
     The default implementation validates against the following headers:
     
     - X-SG-ID
     - X-SG-EID
     - Received
     - DKIM-Signature
     - Content-Type
     - Content-Transfer-Encoding
     - To
     - From
     - Subject
     - Reply-To
     - CC
     - BCC
     
     */
    public func validate(headers: [String:String]) throws {
        let reserved: [String] = [
            "x-sg-id",
            "x-sg-eid",
            "received",
            "dkim-signature",
            "content-type",
            "content-transfer-encoding",
            "to",
            "from",
            "subject",
            "reply-to",
            "cc",
            "bcc"
        ]
        for (key, _) in headers {
            guard reserved.index(of: key.lowercased()) == nil else { throw SGError.Mail.headerNotAllowed(key) }
            let regex = try NSRegularExpression(pattern: "(\\s)", options: [.caseInsensitive, .anchorsMatchLines])
            guard regex.numberOfMatches(in: key, options: [], range: NSMakeRange(0, key.characters.count)) == 0 else {
                throw SGError.Mail.malformedHeader(key)
            }
        }
    }
}
