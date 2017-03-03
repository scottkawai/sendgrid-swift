//
//  ContentType.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/13/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `ContentType` enum represents the common types of Content Types used when sending through the SendGrid API.
 
 */
public enum ContentType: CustomStringConvertible, Validatable {
    
    // MARK: - Cases
    //=========================================================================
    
    /// Represents "application/x-www-form-urlencoded" encodings.
    case formUrlEncoded
    
    /// The "application/json" content type.
    case json
    
    /// The "text/plain" content type, used for the plain text portion of an email.
    case plainText
    
    /// The "text/html" content type, used for the HTML portion of an email.
    case htmlText
    
    /// The "application/csv" content type, used for CSV attachments.
    case csv
    
    /// The "application/pdf" content type, used for PDF attachments.
    case pdf
    
    /// The "application/zip" content type, used for Zip file attachments.
    case zip
    
    /// The "image/png" content type, used for PNG images.
    case png
    
    /// The "image/jpeg" content type, used for JPEG images.
    case jpeg
    
    /// A case used for any content type that isn't explicity stated in the enum.
    case other(String)
    
    // MARK: - Properties
    //=========================================================================
    
    /// The string value of the content type.
    public var description: String {
        switch self {
        case .formUrlEncoded:
            return "application/x-www-form-urlencoded"
        case .json:
            return "application/json"
        case .plainText:
            return "text/plain"
        case .htmlText:
            return "text/html"
        case .csv:
            return "application/csv"
        case .pdf:
            return "application/pdf"
        case .zip:
            return "application/zip"
        case .png:
            return "image/png"
        case .jpeg:
            return "image/jpeg"
        case .other(let str):
            return str
        }
    }
    
    /// An index to make sure the content types are in the proper order.
    var index: Int {
        switch self {
        case .plainText:
            return 0
        case .htmlText:
            return 1
        default:
            return 2
        }
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /**
     
     Initializes the enum with a String representing the Content-Type.
     
     - parameter description:	A string representation of the Content-Type.
     
     */
    public init(description: String) {
        switch description {
        case "application/csv", "text/csv":
            self = .csv
        case "application/json", "text/json":
            self = .json
        case "application/x-www-form-urlencoded":
            self = .formUrlEncoded
        case "text/plain":
            self = .plainText
        case "text/html":
            self = .htmlText
        case "application/pdf":
            self = .pdf
        case "application/zip":
            self = .zip
        case "image/png":
            self = .png
        case "image/jpeg":
            self = .jpeg
        default:
            self = .other(description)
        }
    }
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Validates the content type's description.
     
     */
    public func validate() throws {
        guard !Validator.clrfValidator(self.description).valid
            && self.description.characters.count > 0 else {
            throw SGError.Mail.invalidContentType(self.description)
        }
    }
    
}
