//
//  Attachment.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/17/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `Attachment` class represents a file to attach to an email.
 
 */
open class Attachment: JSONConvertible, Validatable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The content, or data, of the attachment.
    open let content: Data
    
    /// The filename of the attachment.
    open let filename: String
    
    /// The content (or MIME) type of the attachment.
    open let type: ContentType?
    
    /// The content-disposition of the attachment specifying how you would like the attachment to be displayed. For example, "inline" results in the attached file being displayed automatically within the message while "attachment" results in the attached file requiring some action to be taken before it is displayed (e.g. opening or downloading the file).
    open let disposition: ContentDisposition
    
    /// A unique id that you specify for the attachment. This is used when the disposition is set to "inline" and the attachment is an image, allowing the file to be displayed within the body of your email. Ex: `<img src="cid:ii_139db99fdb5c3704"></img>`
    open let contentID: String?
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the attachment.
    open var dictionaryValue: [AnyHashable: Any] {
        var hash: [AnyHashable: Any] = [
            "filename": self.filename,
            "content": self.content.base64EncodedString(options: []),
            "disposition": self.disposition.rawValue
        ]
        if let t = self.type {
            hash["type"] = t.description
        }
        if let cid = self.contentID {
            hash["content_id"] = cid
        }
        return hash
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    /**
     
     Initializes the attachment.
     
     - parameter filename:      The filename of the attachment.
     - parameter content:       The data of the attachment.
     - parameter disposition:   The content-disposition of the attachment (defaults to `ContentDisposition.Attachment`).
     - parameter type:          The content-type of the attachment.
     - parameter contentID:     The CID of the attachment, used to show the attachments inline with the body of the email.
     
     */
    public init(filename: String, content: Data, disposition: ContentDisposition = .attachment, type: ContentType? = nil, contentID: String? = nil) {
        self.filename = filename
        self.content = content
        self.disposition = disposition
        self.type = type
        self.contentID = contentID
    }
    
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Validates that the content type of the attachment is correct.
     
     */
    open func validate() throws {
        try self.type?.validate()
        
        if let id = self.contentID {
            guard Validator.clrfValidator(id).valid && id.characters.count == 0 else {
                throw SGError.Mail.invalidContentID(id)
            }
        }
        
        guard !Validator.clrfValidator(self.filename).valid && self.filename.characters.count > 0 else {
            throw SGError.Mail.invalidFilename(self.filename)
        }
    }
    
}
