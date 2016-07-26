//
//  Content.swift
//  SendGrid
//
//  Created by Scott Kawai on 7/26/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `Content` class represents a MIME part of the email message (i.e. the plain text and HTML parts of an email).
 
 */
public class Content: JSONConvertible, Validatable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The content type of the content.
    public let type: ContentType
    
    /// The value of the content.
    public let value: String
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the content.
    public var dictionaryValue: [NSObject : AnyObject] {
        return [
            "type": self.type.description,
            "value": self.value
        ]
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    /**
     
     Initializes the content with a content type and value.
     
     - parameter contentType:	The content type.
     - parameter value:         The value of the content.
     
     */
    public init(contentType: ContentType, value aValue: String) {
        self.type = contentType
        self.value = aValue
    }
    
    /**
     
     Creates a new `Content` instance used to represent a plain text body.
     
     - parameter value:	The plain text value of the body.
     
     - returns: A `Content` instance with the "text/plain" content type.
     
     */
    public class func plainTextContent(value: String) -> Content {
        return Content(contentType: ContentType.PlainText, value: value)
    }
    
    /**
     
     Creates a new `Content` instance used to represent an HTML body.
     
     - parameter value:	The HTML text value of the body.
     
     - returns: A `Content` instance with the "text/html" content type.
     
     */
    public class func htmlContent(value: String) -> Content {
        return Content(contentType: ContentType.HTMLText, value: value)
    }
    
    /**
     
     Return an array containing a plain text and html body.
     
     - parameter plain:	The text value for the plain text body.
     - parameter html:  The HTML text value for the HTML body.
     
     - returns: An array of `Content` instances.
     
     */
    public class func emailContent(plain plain: String, html: String) -> [Content] {
        return [
            Content.plainTextContent(plain),
            Content.htmlContent(html)
        ]
    }
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Validates the content.
     
     */
    public func validate() throws {
        try self.type.validate()
        if self.value.characters.count == 0 {
            throw Error.Mail.ContentHasEmptyString
        }
    }
    
}